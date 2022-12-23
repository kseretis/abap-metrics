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

at selection-screen.
  flow_worker->check_mandatory_fields( ).

start-of-selection.

  "if it's going to be analyzed by package
  if is_pack = abap_true.
    "input validation
    data(popup) = new z_popup_window( ).
    data object_list type standard table of rseui_set.
    data object_list_with_classes like object_list.

    loop at s_pack reference into data(package).
      clear object_list.
      call function 'RS_GET_OBJECTS_OF_DEVCLASS'
        exporting
          devclass   = package->low
        tables
          objectlist = object_list.

      "save in the temp table only the classes/interafaces
      clear object_list_with_classes.
      object_list_with_classes = object_list.
      delete object_list_with_classes where obj_type <> zif_metrics=>obj_type-clas.

      "if one of the internal tables is empty the we create an error message
      if object_list is initial.
        message e006(z_messages) into data(msg).
        popup->add_message( value #( object = package->low
                                     message = msg ) ).
      elseif object_list_with_classes is initial.
        message e007(z_messages) into msg.
        popup->add_message( value #( object = package->low
                                     message = msg ) ).
      else.
        "append classes/interfaces from packages into main table
        loop at object_list_with_classes reference into data(temp_cl).
          insert value #( class_name = temp_cl->obj_name ) into table classes_for_calculation.
        endloop.
      endif.
    endloop.

    if popup->has_messages( ).
      popup->build_display( ).
      popup->display_popup( ).
    endif.

    if popup->get_answer( ) = abap_false.
      return.
    endif.

    "loop at select-option from screen and save the packages into parameters table
    loop at s_pack reference into data(pack).
      parameters = value #( base parameters ( selname = c_sel_name-package
                                                  kind = c_kind-sel_opt
                                                  sign = pack->sign
                                                  option = pack->option
                                                  low = pack->low ) ).
    endloop.

    "if it's going to be analyzed by package
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
        catch cx_class_not_existent into data(ex).
          message s006(z_message) into msg.
          popup->add_message( value #( object = ex->clsname
                                       message = msg ) ).
      endtry.
    endloop.
  endif.

  "call main metrics program and extract the data
  submit /sdf/cd_custom_code_metric exporting list to memory
      with selection-table parameters and return.

  data(output) = new z_salv_output( ).
  "loop at the classes that the user asked for calculation
  loop at classes_for_calculation reference into data(clas).
*  loop at parameters reference into data(parameter) where selname = c_sel_name-name.
    memory_id = |{ z_class_manager=>c_prefix }_{ clas->class_name }|.
    class_stamp = z_class_manager=>import_from_memory( memory_id ).

    try.
        data(class_name) = class_stamp[ 1 ]-obj_name.
        data(class_package) = class_stamp[ 1 ]-devclass.

        data(new_class) = new z_class( name    = conv #( class_name )
                                       package = conv #( class_package ) ).
        new_class->set_methods( class_stamp ).

*        insert value #( class = new_class ) into table classes.
        data(metrics_facade) = new z_calc_metrics_facade( class_stamp         = new_class
                                                          static_object_calls = cb_cbo ).
        metrics_facade->calculate_metrics( ).
        output->insert_methods_to_table( new_class ).

      catch cx_sy_itab_line_not_found.
      catch zcx_flow_issue.
        "catch zcx_static_ks. TODO create exception class
    endtry.
  endloop.

  if output->is_table_empty( ) and is_pack = abap_true.
    message s008(z_messages) display like 'E'.
    return.
  elseif output->is_table_empty( ) and is_class = abap_true.
    message s011(z_messages) display like 'E'.
    return.
  endif.

  try.
      output->initialize_output( ).
      output->set_default_layout( rb_clas ).
      output->display( ).
    catch zcx_flow_issue into data(e).
      e->display_exception( ).
  endtry.