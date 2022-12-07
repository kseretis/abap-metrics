class z_weight_des_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    methods constructor
      importing source_code type rswsourcet.
    methods calculate redefinition.

  protected section.

  private section.

endclass.

class z_weight_des_calculator implementation.

  method constructor.
    super->constructor( scan_type   = z_code_scanner=>scan_type-with_keywords
                        source_code = source_code ).
  endmethod.

  method calculate.
    return = lines( get_statements( ) ) + 1.
  endmethod.

endclass.
