class z_cohesion_calculator definition public final create public inheriting from z_code_scanner.

  public section.

    types begin of token_with_keyword_id_struct.
        types line_id type i.
        include type stokes.
        types keyword_id type i.
        types is_matched type abap_bool.
    types end of token_with_keyword_id_struct.
    types token_with_keyword_id_tab_type type standard table of token_with_keyword_id_struct with default key.

    types: begin of cohesion_struct,
             previous_line        type string,
             previous_line_tokens type token_with_keyword_id_tab_type,
             next_line            type string,
             next_line_tokens     type token_with_keyword_id_tab_type,
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
    data keywords type ref to z_keywords.
    data variables type ref to z_variables.
    data tokens type token_with_keyword_id_tab_type.
    data cohesion_table type standard table of cohesion_struct.
    data cohesive_table_simple type standard table of lcom2_struct.
    data lack_of_cohesion type standard table of lcom2_struct.

    methods generate_keywords_ids.
    methods calculate_cohesion_by_line.
    methods build_cohesion_table.
    methods search_for_local_variables.
    methods search_next_for_variable
      importing tokens        type token_with_keyword_id_tab_type
                variable      type string
      returning value(return) type abap_bool.
    methods search_next_for_keyword
      importing tokens        type token_with_keyword_id_tab_type
                keyword       type string
                keyword_id    type i
      returning value(return) type abap_bool.
    methods get_lines_tokens
      importing line          type i
      returning value(return) type token_with_keyword_id_tab_type.
    methods get_lines_tokens_with_ids
      importing line          type i
      returning value(return) type token_with_keyword_id_tab_type.
    methods get_latest_keyword_id
      returning value(return) type i.

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
    generate_keywords_ids( ).
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
          is_cohesive = search_next_for_keyword( tokens     = line->next_line_tokens
                                                 keyword    = <prev_token_line>-str
                                                 keyword_id = <prev_token_line>-keyword_id ).
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
        return = cond #( when line_exists( tokens[ str = keywords->get_close_keyword( keyword )
                                                   keyword_id = keyword_id ] )
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
                                                        previous_line_tokens = get_lines_tokens_with_ids( sy-tabix )
                                                        next_line = condense( source_code[ next_line_counter ] )
                                                        next_line_tokens = get_lines_tokens_with_ids( next_line_counter )
                                                        not_cohesive = 0
                                                        cohesive = 0 ) ).
        next_line_counter += 1.
      endwhile.
      continue.
    endloop.
  endmethod.

  method generate_keywords_ids.
    data(line_number) = 1.
    loop at get_cleaned_source_code( ) assigning field-symbol(<line>).
      loop at get_lines_tokens( sy-tabix ) assigning field-symbol(<tok>).

        "set up keywords' IDs
        data(keyword_id) = cond #( when keywords->is_open_keyword( <tok>-str )
                                        then line_number
                                    when keywords->is_close_keyword( <tok>-str )
                                        then get_latest_keyword_id( )
                                    else 0 ).

        tokens = value #( base tokens ( line_id = line_number
                                           str = <tok>-str
                                           row = <tok>-row
                                           col = <tok>-col
                                           type = <tok>-type
                                           keyword_id = keyword_id
                                           is_matched = cond #( when keywords->is_close_keyword( <tok>-str )
                                                                then abap_true else abap_false ) ) ).
        line_number += 1.
      endloop.
    endloop.
  endmethod.

  method get_lines_tokens.
    return = value #( for i in get_cleaned_tokens( ) where ( row = line ) ( corresponding #( i ) ) ).
  endmethod.

  method get_lines_tokens_with_ids.
    return = value #( for i in tokens where ( row = line ) ( corresponding #( i ) ) ).
  endmethod.

  method get_latest_keyword_id.
    sort tokens descending by line_id.
    loop at tokens assigning field-symbol(<token>) where keyword_id <> 0 and is_matched = abap_false.
      return = <token>-keyword_id.
      <token>-is_matched = abap_true.
      exit.
    endloop.
    sort tokens ascending by line_id.
  endmethod.

endclass.