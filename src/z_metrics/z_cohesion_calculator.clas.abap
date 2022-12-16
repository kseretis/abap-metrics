class z_cohesion_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    types: begin of cohesion_struct,
             previous_line        type string,
             previous_line_tokens type z_code_scanner=>tab_type_stokes,
             next_line            type string,
             next_line_tokens     type z_code_scanner=>tab_type_stokes,
             not_cohesive         type i,
             cohesive             type i,
           end of cohesion_struct.
    types: begin of lcom2_struct,
             lcom2        type string,
             not_cohesive type i,
             cohesive     type i,
           end of lcom2_struct.

    constants lcom2 type string value 'LCOM2'.

    methods constructor
      importing class_name  type seoclsname
                source_code type rswsourcet.
    methods calculate redefinition.

  protected section.

  private section.
    data class_name type seoclsname.
    data attributes type standard table of selopt.
    data cohesion_table type standard table of cohesion_struct.
    data cohesive_table_simple type standard table of lcom2_struct.
    data lack_of_cohesion type standard table of lcom2_struct.
    data keywords type ref to z_keywords.

    methods calculate_cohesion_by_line.
    methods build_cohesion_table.
    methods get_attributes.
    methods get_lines_tokens
      importing line          type i
      returning value(return) type z_code_scanner=>tab_type_stokes.

endclass.

class z_cohesion_calculator implementation.

  method constructor.
    super->constructor( scan_type   = zif_metrics=>scan_type-simple
                        source_code = source_code ).
    me->class_name = class_name.
    keywords = new #( ).
  endmethod.

  method calculate.
    calculate_cohesion_by_line( ).

    cohesive_table_simple = corresponding #( cohesion_table ).

    loop at cohesive_table_simple assigning field-symbol(<line>).
      <line>-lcom2 = lcom2.
      collect <line> into lack_of_cohesion.
    endloop.

    try.
        return = lack_of_cohesion[ 1 ]-not_cohesive - lack_of_cohesion[ 1 ]-cohesive.
        if return < 0.
          return = 0.
        endif.
      catch cx_sy_itab_line_not_found.
        return = 0.
    endtry.
  endmethod.

  method calculate_cohesion_by_line.
    build_cohesion_table( ).
    get_attributes( ).
    loop at cohesion_table reference into data(line).
      data(is_cohesive) = abap_false.
      loop at line->previous_line_tokens assigning field-symbol(<prev_token_line>).

        "check if the token is an attribute or a keyword, if not skip it
        if not ( <prev_token_line>-str in attributes or keywords->is_keyword( <prev_token_line>-str ) ).
          "FIXME
          "potential issue with the keywords(open and close)
          continue.
        endif.
        "if the attributes are the same or the keywords are matching, set cohesive to 1
        loop at line->next_line_tokens assigning field-symbol(<next_token_line>).
          if <prev_token_line>-str = <next_token_line>-str
             or keywords->are_matching( open_keyword = <prev_token_line>-str
                                        close_keyword = <next_token_line>-str ).
            is_cohesive = abap_true.
            line->cohesive = zif_metrics=>cohesive_value.
            exit.
          endif.
        endloop.
        if is_cohesive = abap_true.
          exit.
        endif.
      endloop.
      if is_cohesive = abap_false.
        line->not_cohesive = zif_metrics=>cohesive_value.
      endif.
    endloop.
  endmethod.

  method build_cohesion_table.
    data(source_code) = get_source_code( ).
    loop at source_code assigning field-symbol(<line>).
      "skip first line, because we want to calculate only the body
      if sy-tabix = 1.
        continue.
      endif.
      data(next_line_counter) = sy-tabix + 1.
      while next_line_counter < lines( source_code ).
        cohesion_table = value #( base cohesion_table ( previous_line = condense( <line> )
                                                        previous_line_tokens = get_lines_tokens( sy-tabix )
                                                        next_line = condense( source_code[ next_line_counter ] )
                                                        next_line_tokens = get_lines_tokens( next_line_counter )
                                                        not_cohesive = 0
                                                        cohesive = 0 ) ).
        next_line_counter += 1.
      endwhile.
      continue.
    endloop.
  endmethod.

  method get_attributes.
    try.
        "get class' attributes and set them into a range
        data(tmp_attributes) = cl_oo_class=>get_instance( class_name )->get_attributes( ).
        loop at tmp_attributes assigning field-symbol(<attribute>).
          attributes = value #( base attributes ( sign = 'I'
                                                  option = 'EQ'
                                                  low = <attribute>-cmpname ) ).
        endloop.
      catch cx_class_not_existent.
        "todo
    endtry.
  endmethod.

  method get_lines_tokens.
    loop at get_tokens(  ) assigning field-symbol(<line>) where row = line.
      insert <line> into table return.
    endloop.
  endmethod.

endclass.