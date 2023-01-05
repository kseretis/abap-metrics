class z_cbo_calculator definition public final create public inheriting from z_code_scanner.

  public section.
    methods constructor
      importing source_code         type rswsourcet
                static_object_calls type abap_bool.
    methods calculate redefinition.

  protected section.

  private section.
    data coupling type i value 0.
    data static_object_calls type abap_bool.

endclass.

class z_cbo_calculator implementation.

  method constructor.
    super->constructor( scan_type   = zif_metrics=>scan_type-simple
                        source_code = source_code ).
    me->static_object_calls = static_object_calls.
  endmethod.

  method calculate.
    loop at get_tokens( ) reference into data(token).
      if token->str cs zif_metrics=>method_call-instance
        or ( static_object_calls = abap_true and token->str cs zif_metrics=>method_call-static ).
        coupling += 1.
      endif.
    endloop.
    return = coupling.
  endmethod.

endclass.
