class z_decision_depth_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    methods constructor
      importing source_code type rswsourcet.
    methods calculate redefinition.

  protected section.

  private section.
    data deep type i value 0.
    data deep_total type i value 0.

endclass.

class z_decision_depth_calculator implementation.

  method constructor.
    super->constructor( scan_type   = zif_metrics=>scan_type-with_keywords_depth
                        source_code = source_code ).
  endmethod.

  method calculate.
    data(keywords) = new z_keywords( ).
    loop at get_tokens( ) reference into data(token).
      if keywords->is_open_keyword( token->str ) and token->str <> 'TRY'.
        deep += 1.
        deep_total += deep.
      endif.
      if keywords->is_close_keyword( token->str ) and token->str <> 'ENDTRY'.
        deep -= 1.
      endif.
    endloop.
    return = deep_total.
  endmethod.

endclass.