*&---------------------------------------------------------------------*
*& Include Z_SOFTWARE_METRICS_FLOW
*&---------------------------------------------------------------------*
class flow_worker definition create private.

  public section.
    types object_list_tab_type type standard table of rseui_set with empty key.
    class-methods get_instance
      returning value(return) type ref to flow_worker.

    methods check_mandatory_fields.
    methods has_package_selection
      returning value(return) type abap_bool.
    methods get_popup
      returning value(return) type ref to z_popup_window.
    methods add_popup_message
      importing obj type string
                msg type string.
    methods display_popup.
    methods get_popup_answer.
    methods get_package
      importing pack          type string
      returning value(return) type object_list_tab_type
      raising   zcx_flow_issue.
    methods call_standard_metrics_program.
    methods check_if_table_is_empty
      importing output        type ref to z_salv_output
      returning value(return) type abap_bool
      raising   zcx_flow_issue.
    methods display_final_output
      raising zcx_flow_issue.

  protected section.

  private section.
    class-data instance type ref to flow_worker.
    data popup type ref to z_popup_window.
    data output type ref to z_salv_output.

endclass.

class flow_worker implementation.

  method get_instance.
    if instance is not bound.
      instance = new #( ).
    endif.
    return = instance.
  endmethod.

  method check_mandatory_fields.
    if s_pack is initial and s_class is initial.
      message s005(z_messages) display like 'E'.
      leave screen.
    endif.
  endmethod.

  method has_package_selection.
    return = cond #( when s_pack is not initial then abap_true else abap_false ).
  endmethod.

  method get_popup.
    if popup is not bound.
      popup = new #( ).
    endif.
    return = popup.
  endmethod.

  method add_popup_message.
    get_popup( ).
    popup->add_message( value #( object = obj
                                 message = msg ) ).
  endmethod.

  method get_package.

    data object_list type object_list_tab_type.
    data object_list_with_classes like object_list.

    call function 'RS_GET_OBJECTS_OF_DEVCLASS'
      exporting
        devclass   = pack
      tables
        objectlist = object_list.

    object_list_with_classes = object_list.
    delete object_list_with_classes where obj_type <> zif_metrics=>obj_type-clas.

    "if one of the internal tables is empty the we create an error message
    if object_list is initial.
      message s006(z_messages) into data(msg).
      add_popup_message( obj = pack
                         msg = msg ).
      raise exception new zcx_flow_issue( textid = zif_exception_messages=>obj_does_not_exist ).
    elseif object_list_with_classes is initial.
      message s007(z_messages) into msg.
      add_popup_message( obj = pack
                         msg = msg ).
      raise exception new zcx_flow_issue( textid = zif_exception_messages=>empty_package ).
    endif.

    return = object_list_with_classes.

  endmethod.

  method display_popup.
    popup->display_popup( ).
  endmethod.

  method get_popup_answer.
    if popup->get_answer( ).
      return. "exit
    endif.
  endmethod.

  method call_standard_metrics_program.
    "call main metrics program and extract the data
    submit /sdf/cd_custom_code_metric exporting list to memory
        with selection-table parameters and return.
  endmethod.

  method check_if_table_is_empty.
    me->output = output.
    if me->output->is_table_empty( ) and is_pack = abap_true.
      raise exception new zcx_flow_issue( textid = zif_exception_messages=>no_package ).
    elseif me->output->is_table_empty( ) and is_class = abap_true.
      raise exception new zcx_flow_issue( textid = zif_exception_messages=>no_class ).
    endif.
  endmethod.

  method display_final_output.
*    try.
    output->initialize_output( ).
    output->set_default_layout( rb_clas ).
    output->display( ).
*      catch zcx_flow_issue into data(e).
*
**        raise exception new zcx_flow_issue( textid = e->get_exception( ) ).
*    endtry.
  endmethod.

endclass.