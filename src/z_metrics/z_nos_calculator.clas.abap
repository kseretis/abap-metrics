class z_nos_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    methods constructor
      importing source_code type rswsourcet.
    methods scan_code redefinition.
    methods calculate redefinition.

  protected section.

  private section.

endclass.

class z_nos_calculator implementation.

  method constructor.
    super->constructor( source_code ).
  endmethod.

  method scan_code.
    data tokens type z_code_scanner=>tab_type_stokes.
    data statements type z_code_scanner=>tab_type_sstmnt.
    data(source_code) = get_source_code( ).

    scan abap-source source_code tokens into tokens statements into statements.

    set_tokens( tokens ).
    set_statements( statements ).
  endmethod.

  method calculate.
    return = lines( get_statements( ) ). "probably - 2
  endmethod.

endclass.
