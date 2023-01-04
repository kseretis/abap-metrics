*&---------------------------------------------------------------------*
*& Report z_software_metrics
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report z_software_metrics.

include z_software_metrics_top.
include z_software_metrics_screen.
include z_software_metrics_flow.

initialization.

  data(flow_worker) = flow_worker=>get_instance( ).

  parameters = value #( ( selname = c_sel_name-complexity
                            kind = c_kind-param
                            sign = c_sign-inclu
                            option = c_option-equal
                            low = abap_true )
                         ( selname = c_sel_name-authors
                            kind = c_kind-param
                            sign = c_sign-inclu
                            option = c_option-equal
                            low = abap_true )
                         ( selname = c_sel_name-object
                            kind = c_kind-param
                            sign = c_sign-inclu
                            option = c_option-equal
                            low = zif_metrics=>obj_type-clas ) ).

start-of-selection.

  check flow_worker->check_mandatory_fields( ).

  "if it's going to be analyzed by package
  if flow_worker->has_package_selection( ).
    loop at s_pack reference into data(package).
      try.
          data(object_list) = flow_worker->get_package( conv #( package->low ) ).
          classes_for_calculation = value #( for i in object_list ( class_name = i-obj_name ) ).
        catch zcx_flow_issue into data(flow_exception).
          continue.
      endtry.
    endloop.

    "save the packages from selection-screen in parameters
    parameters = value #( base parameters for j in s_pack ( selname = c_sel_name-package
                                                              kind = c_kind-sel_opt
                                                              sign = j-sign
                                                              option = j-option
                                                              low = j-low ) ).
    "if the package is a super package then fetch the sub-packages
    parameters = value #( base parameters for k in flow_worker->get_sub_packages( )
                                                    ( selname = c_sel_name-package
                                                      kind = c_kind-sel_opt
                                                      sign = c_sign-inclu
                                                      option = c_option-equal
                                                      low = k ) ).

    "if it's going to be analyzed by class
  else.
    "loop at select-option from screen and save the classes into parameters table
    loop at s_class reference into data(cl).
      try.
          cl_oo_class=>get_instance( cl->low ).
          parameters = value #( base parameters ( selname = c_sel_name-name
                                                       kind = c_kind-sel_opt
                                                       sign = cl->sign
                                                       option = cl->option
                                                       low = cl->low ) ).
          insert value #( class_name = cl->low ) into table classes_for_calculation.
        catch cx_class_not_existent into data(no_class_ex).
          message s006(z_messages) into data(msg).
          flow_worker->add_popup_message( obj = conv #( cl->low )
                                          msg = msg ).
      endtry.
    endloop.
  endif.

  if flow_worker->get_popup( )->has_messages( ).
    flow_worker->get_popup( )->build_display( ).
    flow_worker->display_popup( ).
    "if the answer is yes(continue) then we stop the program
    check flow_worker->get_popup_answer( ).
  endif.

  flow_worker->call_standard_metrics_program( ).

  data(output) = new z_salv_output( ).
  data(total) = 0.
  "retrieve the class and the source code from the memory and initialize the class references
  loop at classes_for_calculation reference into data(clas).
    memory_id = |{ z_class_manager=>c_prefix }_{ clas->class_name }|.
    class_stamp = z_class_manager=>import_from_memory( memory_id ).
    try.
        data(class_name) = class_stamp[ 1 ]-obj_name.
        data(class_package) = class_stamp[ 1 ]-devclass.

        data(new_class) = new z_class( name    = conv #( class_name )
                                       package = conv #( class_package ) ).
        new_class->set_methods( class_stamp ).
        clas->class_ref = new_class.

        "calculate total lines per class
        total += flow_worker->calc_total_lines_per_class( new_class ).
      catch cx_sy_itab_line_not_found.
      catch zcx_flow_issue.
    endtry.
  endloop.

  "update total methods counter for the progress indicator bar
  z_progress_indicator=>initialize_indicator( total ).

  "create facade object and calculate metrics for each class reference found.
  "it's the core loop of the program
  loop at classes_for_calculation reference into clas.
    data(count) = sy-tabix.
    try.
        data(metrics_facade) = new z_calc_metrics_facade( class_stamp         = clas->class_ref
                                                          static_object_calls = cb_cbo ).
        metrics_facade->calculate_metrics( cb_test ).
        output->insert_methods_to_table( clas->class_ref ).
      catch zcx_metrics_error.
    endtry.
  endloop.

  try.
      flow_worker->check_if_table_is_empty( output ).
      flow_worker->display_final_output( ).
    catch zcx_flow_issue into flow_exception.
      flow_exception->display_exception( ).
  endtry.