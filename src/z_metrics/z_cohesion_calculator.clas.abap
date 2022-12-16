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
    data variables type ref to z_variables.
    data local_variables type standard table of selopt.
    data cohesion_table type standard table of cohesion_struct.
    data cohesive_table_simple type standard table of lcom2_struct.
    data lack_of_cohesion type standard table of lcom2_struct.
    data keywords type ref to z_keywords.

    methods calculate_cohesion_by_line.
    methods build_cohesion_table.
    methods search_for_local_variables.
    methods search_next_for_variable
      importing tokens        type z_code_scanner=>tab_type_stokes
                variable      type string
      returning value(return) type abap_bool.
    methods search_next_for_keyword
      importing tokens        type z_code_scanner=>tab_type_stokes
                keyword       type string
      returning value(return) type abap_bool.
    methods get_lines_tokens
      importing line          type i
      returning value(return) type z_code_scanner=>tab_type_stokes.

endclass.

class z_cohesion_calculator implementation.

  method constructor.
    super->constructor( scan_type   = zif_metrics=>scan_type-simple
                        source_code = source_code ).
    me->class_name = class_name.
    variables = new #( class_name ).
    keywords = new #( ).
  endmethod.

  method calculate.
    clean_source_code( ).
    search_for_local_variables( ).
    calculate_cohesion_by_line( ).

    cohesive_table_simple = corresponding #( cohesion_table ).

    loop at cohesive_table_simple assigning field-symbol(<line>).
      <line>-lcom2 = lcom2.
      collect <line> into lack_of_cohesion.
    endloop.
    break-point.
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
    break-point.
    loop at cohesion_table reference into data(line).
      data(is_cohesive) = abap_false.
      loop at line->previous_line_tokens assigning field-symbol(<prev_token_line>).

        "if previous token is an attribute then we look up in the next line ONLY for the same attribute
        if variables->is_attribute( <prev_token_line>-str ).
          is_cohesive = search_next_for_variable( tokens   = line->next_line_tokens
                                                  variable = <prev_token_line>-str ).
        elseif variables->contains_local_variable( <prev_token_line>-str ).
          is_cohesive = search_next_for_variable( tokens   = line->next_line_tokens
                                                  variable = variables->clear_inline_variable( <prev_token_line>-str ) ).
          "else if, it's an open keyword we look up in next line ONLY for the close keyword
        elseif keywords->is_open_keyword( <prev_token_line>-str ).
          is_cohesive = search_next_for_keyword( tokens  = line->next_line_tokens
                                                 keyword = <prev_token_line>-str ).
        endif.
        if is_cohesive = abap_true.
          line->cohesive = zif_metrics=>cohesive_value.
          exit.
        endif.
      endloop.
      if is_cohesive = abap_false.
        line->not_cohesive = zif_metrics=>cohesive_value.
      endif.
    endloop.
  endmethod.

  method search_for_local_variables.
    data(is_nextone_a_variable) = abap_false.
    loop at get_cleaned_tokens( ) assigning field-symbol(<token>).
      if is_nextone_a_variable = abap_true.
        variables->append_variable( <token>-str ).
        is_nextone_a_variable = abap_false.
        continue.
      endif.

      if <token>-str = zif_metrics=>local_declaration-data_with_type.
        is_nextone_a_variable = abap_true.
        continue.
      elseif <token>-str cs zif_metrics=>local_declaration-in_line_data.
        variables->append_variable( variables->clear_inline_variable( <token>-str ) ).
      endif.
    endloop.
  endmethod.

  method search_next_for_variable.
    return = cond #( when line_exists( tokens[ str = variable ] ) then abap_true else abap_false ).
  endmethod.

  method search_next_for_keyword.
    try.
        return = cond #( when line_exists( tokens[ str = keywords->get_close_keyword( keyword ) ] )
           then abap_true else abap_false ).
      catch zcx_metrics_error.
        return = abap_false.
    endtry.
  endmethod.

  method build_cohesion_table.
    data(source_code) = get_cleaned_source_code( ).
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

  method get_lines_tokens.
    loop at get_cleaned_tokens(  ) assigning field-symbol(<line>) where row = line.
      insert <line> into table return.
    endloop.
  endmethod.

endclass.