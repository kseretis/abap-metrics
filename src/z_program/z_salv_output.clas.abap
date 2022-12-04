class z_salv_output definition public final create public.

  public section.
    types: begin of output_struct,
             package                      type string,
             class_name                   type string,
             method_name                  type string,
             lines_of_code                type i,
             number_of_comments           type i,
             number_of_statements         type i,
             number_of_pragmas            type i,
             complexity_of_conditions     type i,
             number_of_authors            type i,
             complex_weighted_by_decision type i,
             lack_of_cohesion             type i,
             coupling_between_object      type i,
           end of output_struct.
    types output_tab_type type standard table of output_struct.

    methods constructor.
    methods insert_methods_to_table
      importing class_stamp type ref to z_class
      raising   zcx_flow_issue.
    methods initialize_output
      raising zcx_flow_issue.
    methods display.

  protected section.

  private section.
    data results_table type output_tab_type.
*    data class_stamp type ref to z_class.
    data output type ref to cl_salv_table.

    methods apply_settings.

endclass.

class z_salv_output implementation.

  method constructor.
    "
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
                                    lack_of_cohesion = meth->method->get_lack_of_cohesion( )
                                    coupling_between_object = meth->method->get_coupling_between_obj( ) ) ).
        endloop.
      catch zcx_flow_issue.
    endtry.
  endmethod.

  method display.
    output->display( ).
  endmethod.

endclass.