class z_progress_indicator definition public final create private.

  public section.
    class-methods initialize_indicator
      importing max type i.
    class-methods update_indicator
      importing value1 type string optional
                value2 type string optional.

  protected section.

  private section.
    class-data counter type i value 0.
    class-data total type i.
    class-data progress type p length 3 decimals 3.
    class-data progress_100 type p length 3 decimals 1.
    class-data percentage type string.

endclass.

class z_progress_indicator implementation.

  method initialize_indicator.
    total = max.
  endmethod.

  method update_indicator.
    counter += 1.
    progress = counter / total.
    progress_100 = progress * 100.
    percentage = |{ progress_100 }%|.

    cl_progress_indicator=>progress_indicate(
      i_text               = |{ percentage } { value1 }-{ value2 }|
      i_output_immediately = abap_true ).
  endmethod.

endclass.