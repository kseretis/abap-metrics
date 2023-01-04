class z_salv_output definition public final create public.

  public section.
    types output_tab_type type standard table of zst_abap_metrics.

    methods insert_methods_to_table
      importing class_stamp type ref to z_class
      raising   zcx_flow_issue.
    methods is_table_empty
      returning value(return) type abap_bool.
    methods initialize_output
      raising zcx_flow_issue.
    methods display.
    methods set_default_layout
      importing is_calc_by_class type abap_bool
                is_aggregation_total type abap_bool
      raising   zcx_flow_issue.

  protected section.

  private section.
    data results_table type output_tab_type.
    data output type ref to cl_salv_table.

    methods apply_settings.
    methods set_sorts
      importing is_calc_by_class type abap_bool
      raising   zcx_flow_issue.
    methods set_aggregations
        importing is_aggregation_total type abap_bool
      raising zcx_flow_issue.
    methods raise_build_failed_exception
      raising zcx_flow_issue.

endclass.

class z_salv_output implementation.

  method initialize_output.
    try.
        cl_salv_table=>factory(
          importing
            r_salv_table = output
          changing
            t_table      = results_table ).
        apply_settings( ).
      catch cx_salv_msg.
        raise_build_failed_exception( ).
    endtry.
  endmethod.

  method apply_settings.
    output->get_functions( )->set_all( abap_true ).
    output->get_columns( )->set_optimize( abap_true ).
    output->get_display_settings( )->set_striped_pattern( abap_true ).
    output->get_layout( )->set_key( value salv_s_layout_key( report = sy-repid ) ).
    output->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
  endmethod.

  method set_default_layout.
    set_sorts( is_calc_by_class ).
    set_aggregations( is_aggregation_total ).
  endmethod.

  method set_sorts.
    data(sorts) = output->get_sorts( ).
    try.
        sorts->add_sort( columnname = 'PACKAGE_NAME'
                         subtotal   = if_salv_c_bool_sap=>true ).
        sorts->add_sort( columnname = 'CLASS_NAME'
                         subtotal   = if_salv_c_bool_sap=>true ).

        if is_calc_by_class = abap_true.
          sorts->set_compressed_subtotal( 'CLASS_NAME' ).
        endif.
      catch cx_salv_not_found.
        raise_build_failed_exception( ).
      catch cx_salv_existing.
        raise_build_failed_exception( ).
      catch cx_salv_data_error.
        raise_build_failed_exception( ).
    endtry.
  endmethod.

  method set_aggregations.
    data(aggregations) = output->get_aggregations( ).
    data(aggregate_by) = cond #( when is_aggregation_total = abap_true
                                    then if_salv_c_aggregation=>total else if_salv_c_aggregation=>average ).
    try.
        aggregations->add_aggregation( columnname  = 'LINES_OF_CODE'
                                       aggregation = aggregate_by ).
        aggregations->add_aggregation( columnname  = 'NUMBER_OF_COMMENTS'
                                       aggregation = aggregate_by ).
        aggregations->add_aggregation( columnname  = 'NUMBER_OF_STATEMENTS'
                                       aggregation = aggregate_by ).
        aggregations->add_aggregation( columnname  = 'NUMBER_OF_PRAGMAS'
                                       aggregation = aggregate_by ).
        aggregations->add_aggregation( columnname  = 'COMPLEXITY_OF_CONDITIONS'
                                       aggregation = aggregate_by ).
        aggregations->add_aggregation( columnname  = 'NUMBER_OF_AUTHORS'
                                       aggregation = if_salv_c_aggregation=>maximum ).
        aggregations->add_aggregation( columnname  = 'COMPLEX_WEIGHTED_BY_DECISION'
                                       aggregation = aggregate_by ).
        aggregations->add_aggregation( columnname  = 'COUPLING_BETWEEN_OBJECT'
                                       aggregation = aggregate_by ).
        aggregations->add_aggregation( columnname  = 'LACK_OF_COHESION'
                                       aggregation = aggregate_by ).
      catch cx_salv_data_error.
        raise_build_failed_exception( ).
      catch cx_salv_not_found.
        raise_build_failed_exception( ).
      catch cx_salv_existing.
        raise_build_failed_exception( ).
    endtry.
  endmethod.

  method insert_methods_to_table.
    try.
        loop at class_stamp->get_methods( ) reference into data(meth).
          results_table = value #( base results_table
                                          ( class_name = class_stamp->get_name( )
                                            package_name = class_stamp->get_package( )
                                            method_name = meth->method->get_name( )
                                            lines_of_code = meth->method->get_lines_of_code( )
                                            number_of_statements = meth->method->get_number_of_statements( )
                                            number_of_comments = meth->method->get_number_of_comments( )
                                            number_of_pragmas = meth->method->get_number_of_pragmas( )
                                            number_of_authors = meth->method->get_number_of_authors( )
                                            complexity_of_conditions = meth->method->get_complexity_of_conditions( )
                                            complex_weighted_by_decision = meth->method->get_complex_weighted_by_decisi( )
                                            lack_of_cohesion = meth->method->get_lack_of_cohesion( )
                                            coupling_between_object = meth->method->get_coupling_between_obj( ) ) ).
        endloop.
      catch zcx_flow_issue.
    endtry.
  endmethod.

  method is_table_empty.
    return = cond #( when results_table is initial then abap_true else abap_false ).
  endmethod.

  method display.
    output->display( ).
  endmethod.

  method raise_build_failed_exception.
    raise exception new zcx_flow_issue( textid = zif_exception_messages=>salv_build_failed ).
  endmethod.

endclass.