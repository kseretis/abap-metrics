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

  protected section.

  private section.
    data source_code type rswsourcet.
    data results type scan_results.
    data statements type tab_type_sstmnt.
    data tokens type tab_type_stokes.

endclass.

class z_code_scanner implementation.

  method constructor.
    me->source_code = source_code.
    me->results = z_code_scanner_factory=>factory( scan_type = scan_type
                                                   source_code = source_code ).
    me->tokens = me->results-tokens.
    me->statements = me->results-statements.
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

endclass.