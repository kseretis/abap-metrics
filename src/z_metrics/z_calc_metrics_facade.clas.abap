class z_calc_metrics_facade definition public final create public.

  public section.
    methods constructor
      importing class_stamp type ref to z_class.
    methods calculate_metrics.

  protected section.

  private section.
    data class_stamp type ref to z_class.

endclass.

class z_calc_metrics_facade implementation.

  method constructor.
    me->class_stamp = class_stamp.
  endmethod.

  method calculate_metrics.
    try.
        break-point.
        loop at class_stamp->get_methods( ) reference into data(meth).
          "calculate LoC
          data(loc_calculator) = new z_loc_calculator( meth->method->get_source_code( ) ).
          loc_calculator->scan_code( ).
          meth->method->set_lines_of_code( loc_calculator->calculate( ) ).

          "calculate NoC
          data(noc_calculator) = new z_noc_calculator( meth->method->get_source_code( ) ).
          noc_calculator->scan_code( ).
          meth->method->set_number_of_comments( noc_calculator->calculate( ) ).

          "calculate NoP
          data(nop_calculator) = new z_nop_calculator( meth->method->get_source_code( ) ).
          nop_calculator->scan_code( ).
          meth->method->set_number_of_pragmas( nop_calculator->calculate( ) ).

          "calculate NoS
          data(nos_calculator) = new z_nos_calculator( meth->method->get_source_code( ) ).
          nos_calculator->scan_code( ).
          meth->method->set_number_of_statements( nos_calculator->calculate( ) ).
        endloop.
      catch zcx_flow_issue.
    endtry.
  endmethod.

endclass.
