class z_complex_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    constants: begin of tokens,
                 or  type string value 'OR',
                 and type string value 'AND',
               end of tokens.

    methods constructor
      importing source_code type rswsourcet.
    methods calculate redefinition.

  protected section.

  private section.
    data com_sum type i value 0.

endclass.

class z_complex_calculator implementation.

  method constructor.
    super->constructor( scan_type   = z_code_scanner=>scan_type-with_keywords
                        source_code = source_code ).
  endmethod.

  method calculate.
    loop at get_tokens( ) reference into data(token) where str = tokens-or or str = tokens-and.
      com_sum += 1.
    endloop.
    return = com_sum.
  endmethod.

endclass.