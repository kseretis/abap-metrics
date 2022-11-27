class z_loc_calculator definition public create public inheriting from z_code_scanner.

  public section.
    methods constructor
      importing source_code type rswsourcet.
    methods scan_code redefinition.
    methods calculate redefinition.

  protected section.

  private section.

endclass.

class z_loc_calculator implementation.

  method constructor.
    super->constructor( source_code ).
  endmethod.

  method scan_code.
    metric_result = lines( get_source_code( ) ).
  endmethod.

  method calculate.
    return = metric_result. "probably - 2
  endmethod.

endclass.
