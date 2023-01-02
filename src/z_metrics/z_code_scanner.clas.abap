class z_code_scanner definition public abstract create public.

  public section.
    types tab_type_sstmnt type standard table of sstmnt initial size 100 with default key.
    types tab_type_stokes type standard table of stokes initial size 100 with default key.
    types: begin of scan_results,
             statements type tab_type_sstmnt,
             tokens     type tab_type_stokes,
           end of scan_results.

    methods constructor
      importing scan_type   type string
                source_code type rswsourcet.
    methods get_source_code
      returning value(return) type rswsourcet.
    methods get_statements
      returning value(return) type tab_type_sstmnt.
    methods set_statements
      importing statements type tab_type_sstmnt.
    methods get_tokens
      returning value(return) type tab_type_stokes.
    methods set_tokens
      importing tokens type tab_type_stokes.
    methods calculate abstract
      returning value(return) type i.
    methods clean_source_code
      importing value(only_body) type abap_bool default abap_false.
    methods get_cleaned_source_code
      returning value(return) type rswsourcet.
    methods get_cleaned_statements
      returning value(return) type tab_type_sstmnt.
    methods get_cleaned_tokens
      returning value(return) type tab_type_stokes.

  protected section.

  private section.
    data source_code type rswsourcet.
    data statements type tab_type_sstmnt.
    data tokens type tab_type_stokes.
    data cleaned_source_code type rswsourcet.
    data cleaned_statements type tab_type_sstmnt.
    data cleaned_tokens type tab_type_stokes.

endclass.

class z_code_scanner implementation.

  method constructor.
    me->source_code = source_code.
    data(results) = z_code_scanner_factory=>factory( scan_type   = scan_type
                                                     source_code = source_code ).
    me->tokens = results-tokens.
    me->statements = results-statements.
  endmethod.

  method get_source_code.
    return = source_code.
  endmethod.

  method get_statements.
    return = statements.
  endmethod.

  method set_statements.
    me->statements = statements.
  endmethod.

  method get_tokens.
    return = tokens.
  endmethod.

  method set_tokens.
    me->tokens = tokens.
  endmethod.

  method clean_source_code.
    "delete first and last line of source_code if we are calculating lack of cohesion
    if only_body = abap_true.
      delete source_code index 1.
      delete source_code index lines( source_code ).
    endif.

    loop at source_code assigning field-symbol(<line>) where table_line is not initial.
      data(first_char) = condense( <line> ).
      try.
          first_char = first_char+0(1).
          if first_char <> '"' and first_char <> '*' .
            insert <line> into table cleaned_source_code.
          endif.
        catch cx_sy_range_out_of_bounds.
      endtry.
    endloop.
    "re-calculate tokens and statements based on the cleaned source_code
    data(results) = z_code_scanner_factory=>factory( scan_type   = zif_metrics=>scan_type-simple
                                                     source_code = cleaned_source_code ).
    cleaned_tokens = results-tokens.
    cleaned_statements = results-statements.
  endmethod.

  method get_cleaned_source_code.
    return = cleaned_source_code.
  endmethod.

  method get_cleaned_statements.
    return = cleaned_statements.
  endmethod.

  method get_cleaned_tokens.
    return = cleaned_tokens.
  endmethod.

endclass.