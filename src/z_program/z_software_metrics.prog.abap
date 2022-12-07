*&---------------------------------------------------------------------*
*& Report z_software_metrics
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report z_software_metrics.

include z_software_metrics_top.
include z_software_metrics_screen.

initialization.
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
                            low = 'CLAS' ) ).

start-of-selection.

  "input validation
  data(popup) = new z_popup_window( ).

  loop at s_pack reference into data(package).
    data object_list type standard table of rseui_set.
    call function 'RS_GET_OBJECTS_OF_DEVCLASS'
      exporting
        devclass   = package->low
      tables
        objectlist = object_list.

    "save in the temp table only the classes/interafaces
    data(object_list_with_classes) = object_list.
    delete object_list_with_classes where obj_type <> obj_type.

    "if one of the internal tables is empty the we create an error message
    if object_list is initial.
      message e006(z_messages) into data(msg).
      popup->add_message( value #( object = package->low
                                   message = msg ) ).
    elseif object_list_with_classes is initial.
      message e007(z_messages) into msg.
      popup->add_message( value #( object = package->low
                                   message = msg ) ).
    endif.
  endloop.

  if popup->has_messages( ).
    popup->build_display( ).
    popup->display_popup( ).
  endif.

  if popup->get_answer( ) = abap_false.
    exit.
  endif.

  "loop at select-option from screen and save the classes into parameters table
  loop at s_class reference into data(cl).
    parameters = value #( base parameters ( selname = c_sel_name-name
                                                 kind = c_kind-sel_opt
                                                 sign = cl->sign
                                                 option = cl->option
                                                 low = cl->low ) ).
  endloop.

  "call main metrics program and extract the data
  submit /sdf/cd_custom_code_metric exporting list to memory
      with selection-table parameters and return.

  "loop at the classes that the user asked for calculation
  loop at parameters reference into data(parameter) where selname = c_sel_name-name.
    memory_id = |{ z_class_manager=>c_prefix }_{ parameter->low }|.
    class_stamp = z_class_manager=>import_from_memory( memory_id ).

    try.
        data(class_name) = class_stamp[ 1 ]-obj_name.
        data(class_package) = class_stamp[ 1 ]-devclass.

        data(new_class) = new z_class( name    = conv #( class_name )
                                       package = conv #( class_package ) ).
        new_class->set_methods( class_stamp ).

        insert value #( class = new_class ) into table classes.

      catch cx_sy_itab_line_not_found.
        "catch zcx_static_ks. TODO create exception class
    endtry.
  endloop.

  data(output) = new z_salv_output( ).
  "fixme
  loop at classes reference into data(copy).
    data(metrics_facade) = new z_calc_metrics_facade( class_stamp         = copy->class
                                                      static_object_calls = cb_cbo ).
    metrics_facade->calculate_metrics( ).
    try.
        output->insert_methods_to_table( copy->class ).
      catch zcx_flow_issue.
    endtry.
  endloop.

  try.
      output->initialize_output( ).
      output->set_default_layout( ).
      output->display( ).
    catch zcx_flow_issue.
    catch cx_salv_not_found.
    catch cx_salv_existing.
    catch cx_salv_data_error.
  endtry.