class z_noc_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    methods constructor
      importing source_code type rswsourcet.
    methods calculate redefinition.

  protected section.

  private section.
    data comments type i value 0.

endclass.

class z_noc_calculator implementation.

  method constructor.
    super->constructor( scan_type   = zif_metrics=>scan_type-with_comments
                        source_code = source_code ).
  endmethod.

  method calculate.
    loop at get_tokens( ) reference into data(token) ##NEEDED
        where type = zif_metrics=>token_type-comment or type = zif_metrics=>token_type-pragma.
      comments += 1.
    endloop.
    return = comments.
  endmethod.

endclass.
