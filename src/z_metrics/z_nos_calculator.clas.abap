class z_nos_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    methods constructor
      importing source_code type rswsourcet.
    methods calculate redefinition.

  protected section.

  private section.

endclass.

class z_nos_calculator implementation.

  method constructor.
    super->constructor( scan_type   = zif_metrics=>scan_type-simple
                        source_code = source_code ).
  endmethod.

  method calculate.
    return = lines( get_statements( ) ).
  endmethod.

endclass.
