class z_progress_indicator definition public final create private.

  public section.
    class-methods get_instance
      returning value(return) type ref to z_progress_indicator.
    methods initialize_indicator
      importing max type i.
    methods update_indicator
      importing value1 type string optional
                value2 type string optional
      raising   zcx_flow_issue.

  protected section.

  private section.
    class-data instance type ref to z_progress_indicator.
    data counter type i.
    data total type i.
    data progress type p length 3 decimals 3.
    data progress_100 type p length 3 decimals 1.

endclass.

class z_progress_indicator implementation.

  method get_instance.
    if instance is not bound.
      instance = new #( ).
    endif.
    return = instance.
  endmethod.

  method initialize_indicator.
    counter = 0.
    total = max.
  endmethod.

  method update_indicator.
    counter += 1.
    try.
        progress = counter / total.
      catch cx_sy_zerodivide ##NO_HANDLER.
        raise exception new zcx_flow_issue( textid = zif_exception_messages=>zero_divider ).
    endtry.
    progress_100 = progress * 100.
    data(percentage) = |{ progress_100 }%|.

    cl_progress_indicator=>progress_indicate(
      i_text               = |{ percentage } { value1 }-{ value2 }|
      i_output_immediately = abap_true ).
  endmethod.

endclass.
