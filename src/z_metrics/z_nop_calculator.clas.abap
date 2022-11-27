class z_nop_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    methods constructor
      importing source_code type rswsourcet.
    methods scan_code redefinition.
    methods calculate redefinition.

  protected section.

  private section.

endclass.

class z_nop_calculator implementation.

  method constructor.
    super->constructor( source_code ).
  endmethod.

  method scan_code.
    data tokens type z_code_scanner=>tab_type_stokes.
    data statements type z_code_scanner=>tab_type_sstmnt.
    data(source_code) = get_source_code( ).

    scan abap-source source_code tokens into tokens statements into statements
       with comments.

    set_tokens( tokens ).
    set_statements( statements ).
  endmethod.

  method calculate.
    loop at get_tokens( ) reference into data(token)
        where type = z_code_scanner=>token_type-pragma.

      if token->str(1) = '"'.
        if token->str cp '"##AU *' or token->str cs '"#EC'.
          metric_result += 1.
        endif.
      elseif token->str cp '##*'.
        metric_result += 1.
      endif.
    endloop.
  endmethod.

endclass.
