class z_salv_output definition public final create public.

  public section.
    types output_tab_type type standard table of zst_abap_metrics.
    class-data default_layout type slis_vari value '/DEFAULT'.

    methods constructor.
    methods insert_methods_to_table
      importing class_stamp type ref to z_class
      raising   zcx_flow_issue.
    methods is_table_empty
      returning value(return) type abap_bool.
    methods initialize_output
      raising zcx_flow_issue.
    methods display.
    methods set_default_layout
      raising
        cx_salv_not_found
        cx_salv_existing
        cx_salv_data_error.

  protected section.

  private section.
    data results_table type output_tab_type.
    data output type ref to cl_salv_table.

    methods apply_settings.
    methods set_sorts.
    methods set_aggregations.

endclass.

class z_salv_output implementation.

  method constructor.
    "empty constructor
  endmethod.

  method initialize_output.
    try.
        cl_salv_table=>factory(
          importing
            r_salv_table = output
          changing
            t_table      = results_table ).
        apply_settings( ).
      catch cx_salv_msg.
        raise exception new zcx_flow_issue( textid = zcx_flow_issue=>salv_build_failed ).
    endtry.

  endmethod.

  method apply_settings.
    output->get_functions( )->set_all( abap_true ).
    output->get_columns( )->set_optimize( abap_true ).
    output->get_display_settings( )->set_striped_pattern( abap_true ).
    output->get_layout( )->set_key( value salv_s_layout_key( report = sy-repid ) ).
    output->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    output->get_layout( )->set_initial_layout( default_layout ).
  endmethod.

  method set_default_layout.
    set_sorts( ).
    set_aggregations( ).
  endmethod.

  method set_sorts.
    data(sorts) = output->get_sorts( ).
    try.
        sorts->add_sort( columnname = 'PACKAGE'
                         subtotal   = if_salv_c_bool_sap=>true ).
        sorts->add_sort( columnname = 'CLASS_NAME'
                         subtotal   = if_salv_c_bool_sap=>true ).
      catch cx_salv_not_found.
      catch cx_salv_existing.
      catch cx_salv_data_error.
    endtry.
  endmethod.

  method set_aggregations.
    data(aggregations) = output->get_aggregations( ).
    try.
        aggregations->add_aggregation( columnname  = 'LINES_OF_CODE'
                                       aggregation = if_salv_c_aggregation=>total ).
        aggregations->add_aggregation( columnname  = 'NUMBER_OF_COMMENTS'
                                       aggregation = if_salv_c_aggregation=>total ).
        aggregations->add_aggregation( columnname  = 'NUMBER_OF_STATEMENTS'
                                       aggregation = if_salv_c_aggregation=>total ).
        aggregations->add_aggregation( columnname  = 'NUMBER_OF_PRAGMAS'
                                       aggregation = if_salv_c_aggregation=>total ).
        aggregations->add_aggregation( columnname  = 'COMPLEXITY_OF_CONDITIONS'
                                       aggregation = if_salv_c_aggregation=>total ).
        aggregations->add_aggregation( columnname  = 'NUMBER_OF_AUTHORS'
                                       aggregation = if_salv_c_aggregation=>total ).
        aggregations->add_aggregation( columnname  = 'COMPLEX_WEIGHTED_BY_DECISION'
                                       aggregation = if_salv_c_aggregation=>total ).
        aggregations->add_aggregation( columnname  = 'COUPLING_BETWEEN_OBJECT'
                                       aggregation = if_salv_c_aggregation=>total ).
      catch cx_salv_data_error.
      catch cx_salv_not_found.
      catch cx_salv_existing.
    endtry.
  endmethod.

  method insert_methods_to_table.
    try.
        loop at class_stamp->get_methods( ) reference into data(meth).
          results_table = value #( base results_table
                                  ( class_name = class_stamp->get_name( )
                                    package = class_stamp->get_package( )
                                    method_name = meth->method->get_name( )
                                    lines_of_code = meth->method->get_lines_of_code( )
                                    number_of_statements = meth->method->get_number_of_statements( )
                                    number_of_comments = meth->method->get_number_of_comments( )
                                    number_of_pragmas = meth->method->get_number_of_pragmas( )
                                    number_of_authors = meth->method->get_number_of_authors( )
                                    complexity_of_conditions = meth->method->get_complexity_of_conditions( )
                                    complex_weighted_by_decision = meth->method->get_complex_weighted_by_decisi( )
                                    "lack_of_cohesion = meth->method->get_lack_of_cohesion( )
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

endclass.