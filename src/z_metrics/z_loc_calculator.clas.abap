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
    super->constructor( scan_type   = zif_metrics=>scan_type-none
                        source_code = source_code ).
  endmethod.

  method calculate.
    clean_source_code( ).
    return = lines( get_cleaned_source_code( ) ).
  endmethod.

endclass.