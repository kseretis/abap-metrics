class z_cohesion_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    types: begin of cohesion_struct,
             previous        type string,
             previous_tokens type z_code_scanner=>tab_type_stokes,
             next            type string,
             next_tokens     type z_code_scanner=>tab_type_stokes,
             not_cohesive    type i,
             cohesive        type i,
           end of cohesion_struct.
    types: begin of parameters_struct,
             class_name  type string,
             method_name type string,
             parameter   type string,
           end of parameters_struct.
    types: begin of keywords_struct,
             open  type string,
             close type string,
           end of keywords_struct.
    types keywords_tab_type type standard table of keywords_struct.

    methods constructor
      importing class_name  type seoclsname
                method_name type seosconame
                source_code type rswsourcet.
    methods calculate redefinition.

  protected section.

  private section.
    data class_name type seoclsname.
    data attributes type standard table of selopt.
    data method_name type seosconame.
    data parameters type standard table of parameters_struct.
    data cohesion_table type standard table of cohesion_struct.
    data keywords type keywords_tab_type.

    methods build_cohesion_table.
    methods get_attributes.
    methods get_parameters.
    methods initialize_keywords.
    methods is_keyword
      importing key           type string
      returning value(return) type abap_bool.

endclass.

class z_cohesion_calculator implementation.

  method constructor.
    super->constructor( scan_type   = zif_metrics=>scan_type-simple
                        source_code = source_code ).
    me->class_name = class_name.
    me->method_name = method_name.
    initialize_keywords( ).
  endmethod.

  method initialize_keywords.
    keywords = value #( ( open = 'IF' close = 'ENDIF' ) ).
  endmethod.

  method calculate.

    build_cohesion_table( ).
    "1. get class' attributes with cl_oo_class
    "2. loop at cohesion table and split prev n next into string line tab
    "3. check if splitted tokens belong to attributes table
    "4. if they, check the next field if the same token exists
    "5. if yes, then add 1 to shared field else add 1 to not shared

    get_attributes( ).
    get_parameters( ).
    loop at cohesion_table reference into data(line).
      data(is_cohesive) = abap_false.
      loop at line->previous_tokens assigning field-symbol(<prev_token_line>).
*        where str in attributes or is_keyword( str ). "FIXME
        break-point.
        if not ( <prev_token_line>-str in attributes
            or is_keyword( <prev_token_line>-str ) ). "FIXME
          continue.
        endif.

*        if <prev_token_line>-str in attributes.
        loop at line->next_tokens assigning field-symbol(<next_token_line>).
*          where str = <prev_token_line>-str.

          if <prev_token_line>-str = <next_token_line>-str.
            is_cohesive = abap_true.
          else.
            loop at keywords assigning field-symbol(<keyword>)
                where open = <prev_token_line>-str and close = <next_token_line>-str.
              is_cohesive = abap_true.
              exit.
            endloop.
          endif.
          if is_cohesive = abap_true.
            line->cohesive = 1.
            exit.
          endif.
        endloop.
        if is_cohesive = abap_true.
          exit.
        endif.
      endloop.
      if is_cohesive = abap_false.
        line->not_cohesive = 1.
      endif.

    endloop.

  endmethod.

  method is_keyword.
    return = abap_false.
    loop at keywords assigning field-symbol(<keyword>) where open = key.
      return = abap_true.
      exit.
    endloop.
  endmethod.

  method build_cohesion_table.
    data prev_tokens type z_code_scanner=>tab_type_stokes.
    data next_tokens type z_code_scanner=>tab_type_stokes.
    data(source_code) = get_source_code( ).

    loop at source_code assigning field-symbol(<line>).
      "skip first line, because we do want to calculate only the body
      if sy-tabix = 1.
        continue.
      endif.
      data(counter) = sy-tabix + 1.
      "get tokens for previous line
      clear prev_tokens.
      loop at get_tokens(  ) assigning field-symbol(<prev_token>) where row = sy-tabix.
        insert <prev_token> into table prev_tokens.
      endloop.
      while counter < lines( source_code ).
        "get tokens for next line
        clear next_tokens.
        loop at get_tokens(  ) assigning field-symbol(<next_token>) where row = counter.
          insert <next_token> into table next_tokens.
        endloop.
        cohesion_table = value #( base cohesion_table ( previous = <line>
                                                        previous_tokens = prev_tokens
                                                        next = source_code[ counter ]
                                                        next_tokens = next_tokens
                                                        not_cohesive = 0
                                                        cohesive = 0 ) ).
        counter += 1.
      endwhile.
      continue.
    endloop.
  endmethod.

  method get_attributes.
    try.
        data(tmp_attributes) = cl_oo_class=>get_instance( class_name )->get_attributes( ).
        "delete constants from attributes
*        delete tmp_attributes where attdecltyp = zif_metrics=>attribute_decl_level-constant.
        loop at tmp_attributes assigning field-symbol(<attribute>).
          attributes = value #( base attributes ( sign = 'I'
                                                  option = 'EQ'
                                                  low = <attribute>-cmpname ) ).
        endloop.
      catch cx_class_not_existent.
        "todo
    endtry.
  endmethod.

  method get_parameters.
    try.
        data(tmp_parameters) = cl_oo_class=>get_instance( class_name )->method_parameters.
        loop at tmp_parameters assigning field-symbol(<param>).
          parameters = value #( base parameters ( class_name = <param>-clsname
                                                    method_name = <param>-cmpname
                                                    parameter = <param>-sconame ) ).
        endloop.
      catch cx_class_not_existent.
    endtry.
  endmethod.

endclass.