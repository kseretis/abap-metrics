class z_complex_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    methods constructor
      importing source_code type rswsourcet.
    methods calculate redefinition.

  protected section.

  private section.
    data com_sum type i value 0.

endclass.

class z_complex_calculator implementation.

  method constructor.
    super->constructor( scan_type   = zif_metrics=>scan_type-with_keywords
                        source_code = source_code ).
  endmethod.

  method calculate.
    loop at get_tokens( ) reference into data(token) ##NEEDED
        where str = zif_metrics=>tokens-or or str = zif_metrics=>tokens-and.
      com_sum += 1.
    endloop.
    return = com_sum.
  endmethod.

endclass.
