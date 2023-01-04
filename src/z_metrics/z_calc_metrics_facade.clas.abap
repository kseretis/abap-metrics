class z_calc_metrics_facade definition public final create public.

  public section.
    methods constructor
      importing class_stamp         type ref to z_class
                static_object_calls type abap_bool
      raising   zcx_metrics_error.
    methods calculate_metrics
      importing export_cohesion_tab type abap_bool default abap_false.

  protected section.

  private section.
    data class_stamp type ref to z_class.
    data static_object_calls type abap_bool.

endclass.

class z_calc_metrics_facade implementation.

  method constructor.
    if class_stamp is not bound.
      raise exception new zcx_metrics_error( textid = zif_exception_messages=>no_class_found ).
    endif.
    me->class_stamp = class_stamp.
    me->static_object_calls = static_object_calls.
  endmethod.

  method calculate_metrics.
    try.
        loop at class_stamp->get_methods( ) reference into data(meth).
          "update indicator
          z_progress_indicator=>update_indicator( value1 = class_stamp->get_name( )
                                                  value2 = meth->method->get_name( ) ).

          "calculate LoC
          data(loc_calculator) = new z_loc_calculator( meth->method->get_source_code( ) ).
          meth->method->set_lines_of_code( loc_calculator->calculate( ) ).

          "calculate NoC
          data(noc_calculator) = new z_noc_calculator( meth->method->get_source_code( ) ).
          meth->method->set_number_of_comments( noc_calculator->calculate( ) ).

          "calculate NoP
          data(nop_calculator) = new z_nop_calculator( meth->method->get_source_code( ) ).
          meth->method->set_number_of_pragmas( nop_calculator->calculate( ) ).

          "calculate NoS
          data(nos_calculator) = new z_nos_calculator( meth->method->get_source_code( ) ).
          meth->method->set_number_of_statements( nos_calculator->calculate( ) ).

          "calculate complex
          data(complex_calculator) = new z_complex_calculator( meth->method->get_source_code( ) ).
          meth->method->set_complexity_of_conditions( complex_calculator->calculate( ) ).

          "calculate complex weighted by decision
          data(decision_depth) = new z_decision_depth_calculator( meth->method->get_source_code( ) ).
          meth->method->set_complex_weighted_by_decisi( decision_depth->calculate( ) ).

          "calculate coupling between objects
          data(coupling) = new z_cbo_calculator( source_code         = meth->method->get_source_code( )
                                                 static_object_calls = static_object_calls ).
          meth->method->set_coupling_between_obj( coupling->calculate( ) ).

          "number of authors
          try.
              data(authors) = new z_authors_calculator( meth->method->get_full_name( ) ).
              meth->method->set_number_of_authors( authors->find_authors( ) ).

*              "calculate lack of cohesion in methods
              data(lack_of_cohesion) = new z_cohesion_calculator( class_name  = conv #( class_stamp->get_name( ) )
                                                                  method_name = meth->method->get_name( )
                                                                  source_code = meth->method->get_source_code( ) ).
              meth->method->set_lack_of_cohision( lack_of_cohesion->calculate( ) ).
              "test run
              if export_cohesion_tab = abap_true.
                lack_of_cohesion->export_cohesion_table( ).
              endif.
            catch zcx_metrics_error into data(ex).
              ex->display_exception( ).
          endtry.
        endloop.
      catch zcx_flow_issue.
    endtry.
  endmethod.

endclass.