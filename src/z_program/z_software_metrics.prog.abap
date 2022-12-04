*&---------------------------------------------------------------------*
*& Report z_software_metrics
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report z_software_metrics.

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


start-of-selection.

  parameters = value #( ( selname = 'S_NAME'
                            kind = 'S'
                            sign = 'I'
                            option = 'EQ'
                            low = 'ZCL_UTILITIES' ) ). "'ZCL_LOCAL_KS' )
*                        ( selname = 'S_NAME'
*                            kind = 'S'
*                            sign = 'I'
*                            option = 'EQ'
*                            low = 'ZCL_LOCAL_KS' ) ).
*
  submit /sdf/cd_custom_code_metric exporting list to memory
      with selection-table parameters and return.

  break-point.
  loop at parameters reference into data(parameter).
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

  loop at classes reference into data(copy).
    data(metrics_facade) = new z_calc_metrics_facade( copy->class ).
    metrics_facade->calculate_metrics( ).
    break-point.
    data(output) = new z_salv_output( copy->class ).
    try.
        output->build_results_table( ).
        output->initialize_output( ).
      catch zcx_flow_issue.
    endtry.
  endloop.

  output->display( ).
