class z_nop_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    methods constructor
      importing source_code type rswsourcet.
    methods calculate redefinition.

  protected section.

  private section.
    data pragmas type i value 0.

endclass.

class z_nop_calculator implementation.

  method constructor.
    super->constructor( scan_type   = zif_metrics=>scan_type-with_pragmas
                        source_code = source_code ).
  endmethod.

  method calculate.
    loop at get_tokens( ) reference into data(token)
        where type = zif_metrics=>token_type-comment or type = zif_metrics=>token_type-pragma.

      if token->str(1) = '"'.
        if token->str cp '"##AU *' or token->str cs '"#EC'.
          pragmas += 1.
        endif.
      elseif token->str cp '##*'.
        pragmas += 1.
      endif.
    endloop.
    return = pragmas.
  endmethod.

endclass.