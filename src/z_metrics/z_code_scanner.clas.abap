class z_code_scanner definition public abstract create public.

  public section.
    types tab_type_sstmnt type standard table of sstmnt initial size 100 with default key.
    types tab_type_stokes type standard table of stokes initial size 100 with default key.
    types metric type i.

    constants: begin of token_type,
                 comment type string value 'C',
                 pragma  type string value 'P',
               end of token_type.

    methods constructor
      importing source_code type rswsourcet.
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
    methods scan_code.
    methods calculate abstract
      returning value(return) type i.

  protected section.

  private section.
    data source_code type rswsourcet.
    data statements type tab_type_sstmnt.
    data tokens type tab_type_stokes.

endclass.

class z_code_scanner implementation.

  method constructor.
    me->source_code = source_code.
    scan_code( ).
  endmethod.

  method scan_code.
    scan abap-source source_code tokens into tokens statements into statements
       with comments.
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