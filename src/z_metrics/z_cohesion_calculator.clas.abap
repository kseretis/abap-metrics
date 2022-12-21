class z_cohesion_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    types: begin of parenthesis_id,
             parenthesis_id         type i,
             is_parenthesis_matched type abap_bool,
           end of parenthesis_id.
    types parenthesis_ids_tab_type type standard table of parenthesis_id with empty key.

    types: begin of token_with_id_struct,
             line_id            type i.
             include    type stokes.
    types:   keyword_id         type i,
             is_keyword_matched type abap_bool,
             parenthesis_ids    type parenthesis_ids_tab_type,
           end of token_with_id_struct.
    types token_with_id_tab_type type standard table of token_with_id_struct with default key.

    types: begin of cohesion_struct,
             previous_line        type string,
             previous_line_tokens type token_with_id_tab_type,
             next_line            type string,
             next_line_tokens     type token_with_id_tab_type,
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
                source_code type rswsourcet
      raising   zcx_metrics_error.
    methods calculate redefinition.

  protected section.

  private section.
    data class_name type seoclsname.
    data keywords type ref to z_keywords.
    data variables type ref to z_variables.
    data tokens type token_with_id_tab_type.
    data cohesion_table type standard table of cohesion_struct.
    data cohesive_table_simple type standard table of lcom2_struct.
    data lack_of_cohesion type standard table of lcom2_struct.

    methods generate_tokens_ids.
    methods calculate_cohesion_by_line.
    methods build_cohesion_table.
    methods search_for_local_variables.
    methods search_next_for_variable
      importing tokens        type token_with_id_tab_type
                variable      type string
      returning value(return) type abap_bool.
    methods search_next_for_keyword
      importing tokens        type token_with_id_tab_type
                keyword       type string
                keyword_id    type i
      returning value(return) type abap_bool.
    methods search_next_for_parenthesis
      importing tokens          type token_with_id_tab_type
                parenthesis_ids type parenthesis_ids_tab_type
      returning value(return)   type abap_bool.
    methods get_lines_tokens
      importing line          type i
      returning value(return) type token_with_id_tab_type.
    methods get_lines_tokens_with_ids
      importing line          type i
      returning value(return) type token_with_id_tab_type.
    methods get_latest_keyword_id
      returning value(return) type i.
    methods get_latest_parenthesis_id
      returning value(return) type i.
    methods get_keyword_id
      importing token         type string
                line_id       type i
      returning value(return) type i.
    methods get_parenthesis_ids
      importing token         type string
                line_id       type i
      returning value(return) type parenthesis_ids_tab_type.
    methods is_method_call
      importing token         type string
      returning value(return) type abap_bool.
    methods is_method_closing
      importing token         type string
      returning value(return) type abap_bool.
    methods contains_parenthesis
      importing token         type string
      returning value(return) type abap_bool.
    methods are_parenthesis_ids_same
      importing prev_parenthesis_ids type parenthesis_ids_tab_type
                next_parenthesis_ids type parenthesis_ids_tab_type
      returning value(return)        type abap_bool.

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
    generate_tokens_ids( ).
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

    loop at cohesion_table reference into data(line).
      data(is_cohesive) = abap_false.
      loop at line->previous_line_tokens assigning field-symbol(<prev_token_line>).
        "if previous token is an attribute then we look up in the next line ONLY for the same attribute
        if variables->is_attribute( <prev_token_line>-str ) or variables->is_local_variable( <prev_token_line>-str ).
          is_cohesive = search_next_for_variable( tokens   = line->next_line_tokens
                                                  variable = <prev_token_line>-str ).
        elseif variables->contains_variable( <prev_token_line>-str ).
          is_cohesive = search_next_for_variable( tokens   = line->next_line_tokens
                                                  variable = variables->clear_inline_variable( <prev_token_line>-str ) ).
          if is_cohesive = abap_false.
            is_cohesive = search_next_for_parenthesis( tokens          = line->next_line_tokens
                                                       parenthesis_ids = <prev_token_line>-parenthesis_ids ).
          endif.
        elseif contains_parenthesis( <prev_token_line>-str ).
          is_cohesive = search_next_for_parenthesis( tokens          = line->next_line_tokens
                                                     parenthesis_ids = <prev_token_line>-parenthesis_ids ).
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

      if <token>-str = zif_metrics=>local_declaration-data or <token>-str = zif_metrics=>local_declaration-field_symbols.
        is_nextone_a_variable = abap_true.
        continue.
      elseif <token>-str cs zif_metrics=>local_declaration-data or <token>-str cs zif_metrics=>local_declaration-field_symbol.
        variables->append_variable( variables->clear_inline_variable( <token>-str ) ).
      endif.
    endloop.
  endmethod.

  method search_next_for_variable.
    return = abap_false.
    loop at tokens assigning field-symbol(<token>).
      if <token>-str = variable or ( <token>-str cs variable and <token>-str cs |{ variable }-| ).
        return = abap_true.
        exit.
      endif.
    endloop.
  endmethod.

  method search_next_for_parenthesis.
    return = abap_false.
    loop at tokens assigning field-symbol(<token>).
      if is_method_closing( <token>-str ) and are_parenthesis_ids_same( prev_parenthesis_ids = parenthesis_ids
                                                                        next_parenthesis_ids = <token>-parenthesis_ids ).
        return = abap_true.
        exit.
      endif.
    endloop.
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

  method are_parenthesis_ids_same.
    return = abap_false.
    loop at prev_parenthesis_ids assigning field-symbol(<prev>).
      try.
          return = cond #( when line_exists( next_parenthesis_ids[ parenthesis_id = <prev>-parenthesis_id ] )
                              then abap_true else abap_false ).
        catch cx_sy_itab_line_not_found.
          return = abap_false.
      endtry.
    endloop.
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

  method generate_tokens_ids.
    data(line_number) = 1.
    loop at get_cleaned_source_code( ) assigning field-symbol(<line>).
      loop at get_lines_tokens( sy-tabix ) assigning field-symbol(<tok>).
        tokens = value #( base tokens ( line_id = line_number
                                           str = <tok>-str
                                           row = <tok>-row
                                           col = <tok>-col
                                           type = <tok>-type
                                           keyword_id = get_keyword_id( token = <tok>-str
                                                                        line_id = line_number )
                                           is_keyword_matched = cond #( when keywords->is_close_keyword( <tok>-str )
                                                                        then abap_true else abap_false )
                                           parenthesis_ids = get_parenthesis_ids( token   = <tok>-str
                                                                                  line_id = line_number ) ) ).
        line_number += 1.
      endloop.
    endloop.
  endmethod.

  method get_keyword_id.
    return = cond #( when keywords->is_open_keyword( token )
                            then line_id
                       when keywords->is_close_keyword( token )
                            then get_latest_keyword_id( )
                       else 0 ).
  endmethod.

  method get_parenthesis_ids.
    if is_method_call( token ).
      return = value #( base return ( parenthesis_id = line_id
                                      is_parenthesis_matched = abap_false ) ).
      return.
    endif.

    if is_method_closing( token ).
      data(latest_id) = get_latest_parenthesis_id( ).
      return = value #( base return ( parenthesis_id = latest_id
                                      is_parenthesis_matched = abap_true ) ).
    endif.

    "if contains both ) and (
    if contains( val = token sub = zif_metrics=>symbols-parenthesis_close )
        and contains( val = token sub = zif_metrics=>symbols-parenthesis_open ).
      return = value #( base return ( parenthesis_id = ( 0 - latest_id )
                                      is_parenthesis_matched = abap_false ) ).
    endif.
  endmethod.

  method is_method_call.
    "for instance method call or static
    return = cond #(
        when ( variables->contains_variable( token )
                and contains( val = token
                              sub = |{ variables->clear_inline_variable( token ) }{ zif_metrics=>method_call-instance }| ) )
         or contains( val = token sub = zif_metrics=>method_call-static )
         then abap_true else abap_false ).
  endmethod.

  method is_method_closing.
    try.
        return = cond #( when substring( val = token off = 0 len = 3 )
                                = |{ zif_metrics=>symbols-parenthesis_close }{ zif_metrics=>method_call-instance }|
                         then abap_true else abap_false ).
      catch cx_sy_range_out_of_bounds.
        return = cond #( when token = zif_metrics=>symbols-parenthesis_close then abap_true else abap_false ).
    endtry.
  endmethod.

  method contains_parenthesis.
    return = cond #( when contains( val = token sub = zif_metrics=>symbols-parenthesis_open )
                        then abap_true else abap_false ).
  endmethod.

  method get_lines_tokens.
    return = value #( for i in get_cleaned_tokens( ) where ( row = line ) ( corresponding #( i ) ) ).
  endmethod.

  method get_lines_tokens_with_ids.
    return = value #( for i in tokens where ( row = line ) ( corresponding #( i ) ) ).
  endmethod.

  method get_latest_keyword_id.
    sort tokens descending by line_id.
    loop at tokens assigning field-symbol(<token>) where keyword_id <> 0 and is_keyword_matched = abap_false.
      return = <token>-keyword_id.
      <token>-is_keyword_matched = abap_true.
      exit.
    endloop.
    sort tokens ascending by line_id.
  endmethod.

  method get_latest_parenthesis_id.
    data(found) = abap_false.
    sort tokens descending by line_id.
    loop at tokens assigning field-symbol(<token>).
      loop at <token>-parenthesis_ids assigning field-symbol(<par>)
          where parenthesis_id <> 0 and is_parenthesis_matched = abap_false.
        return = <par>-parenthesis_id.
        <par>-is_parenthesis_matched = abap_true.
        found = abap_true.
        exit.
      endloop.
      if found = abap_true.
        exit.
      endif.
    endloop.
    sort tokens ascending by line_id.
  endmethod.

endclass.