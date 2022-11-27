class z_loc_calculator definition public create public inheriting from z_code_scanner.

  public section.
    methods constructor
      importing source_code type rswsourcet.
    methods calculate redefinition.

  protected section.

  private section.

endclass.

class z_loc_calculator implementation.

  method constructor.
    super->constructor( scan_type   = z_code_scanner=>scan_type-none
                        source_code = source_code ).
  endmethod.

  method calculate.
    return = lines( get_source_code( ) ). "probably - 2
  endmethod.

endclass.