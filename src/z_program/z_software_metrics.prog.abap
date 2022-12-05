*&---------------------------------------------------------------------*
*& Report z_software_metrics
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report z_software_metrics.

include z_sofware_metrics_top.
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

at selection-screen on value-request for s_class-low.

    data return_Tab type standard table of DDSHRETVAL.
    call function 'F4IF_FIELD_VALUE_REQUEST'
      exporting
        tabname             = 'SEOCLASS'
        fieldname           = 'CLSNAME'
        searchhelp          = 'SEO_CLASSES_INTERFACES'
*        shlpparam           = s_class-low
*        dynpprog            = space
*        dynpnr              = space
*        dynprofield         = space
*        stepl               = 0
*        value               = s_class-low
*        multiple_choice     = space
*        display             = space
*        suppress_recordlist = space
*        callback_program    = space
*        callback_form       = space
*        callback_method     = callback_method
*        selection_screen    = space
*      importing
*        user_reset          = user_reset
      tables
        return_tab          = return_tab
*      exceptions
*        field_not_found     = 1
*        no_help_for_field   = 2
*        inconsistent_help   = 3
*        no_values_found     = 4
*        others              = 5
.
    if sy-subrc = 0.
        s_class-low = return_tab[ 1 ]-fieldval.
    endif.

at selection-screen.
    if s_pack is initial and s_class is initial.
        message e005(z_messages).
    endif.

start-of-selection.

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
      output->display( ).
    catch zcx_flow_issue.
  endtry.