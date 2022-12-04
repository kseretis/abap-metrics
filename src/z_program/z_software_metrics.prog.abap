*&---------------------------------------------------------------------*
*& Report z_software_metrics
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report z_software_metrics.

tables: tadir.
constants: begin of c_sel_name,
             complexity type string value 'C_MCCABE',
             authors    type string value 'C_VRSD',
             name       type string value 'S_NAME',
           end of c_sel_name.
constants: begin of c_kind,
             param   type c value 'P',
             sel_opt type c value 'S',
           end of c_kind.
constants: begin of c_sign,
             inclu type c value 'I',
             exlcy type c value 'E',
           end of c_sign.
constants: begin of c_option,
             equal     type string value 'EQ',
             not_equal type string value 'NE',
           end of c_option.

include z_software_metrics_screen.

types: begin of class_struc,
         class type ref to z_class,
       end of class_struc.
types classes_tab_type type standard table of class_struc.

data parameters type standard table of rsparams.
*DATA parameter LIKE LINE OF parameters.
data class_stamp type z_class_manager=>class_stamp_tab_type.
*data obj_line type z_object_handler=>object_structure.
data classes type classes_tab_type.
data memory_id(60) type c.


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
                            low = abap_true ) ).

start-of-selection.
  break-point.
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

  "fixme
  loop at classes reference into data(copy).
    data(metrics_facade) = new z_calc_metrics_facade( class_stamp         = copy->class
                                                      static_object_calls = cb_cbo ).
    metrics_facade->calculate_metrics( ).
    data(output) = new z_salv_output( copy->class ).
    try.
        output->build_results_table( ).
        output->initialize_output( ).
      catch zcx_flow_issue.
    endtry.
  endloop.

  output->display( ).