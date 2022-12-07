*"* use this source file for your ABAP unit test classes
class z_calc_metrics_facade_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_calc_metrics_facade.
    data class_instance type ref to z_class.
    data meth type ref to z_method.
    methods setup.
    methods lines_of_code for testing.
    methods number_of_statements for testing.
    methods number_of_comments for testing.
    methods number_of_pragmas for testing.
    methods complexity for testing.
    methods complex_weighted for testing.
    methods coupling for testing.

endclass.

class z_calc_metrics_facade_test implementation.

  method setup.
    class_instance = new #( name    = 'Unit_class'
                            package = 'ZUNIT' ).

    data methods type z_class_manager=>class_stamp_tab_type.

    methods = value #( ( sub_name = 'unit_method1'
                        source = value #( ( `METHOD unit_method.` )
                                            ( ` "comment` )
                                            ( ` z_class_test=>call_test_method( ) ##TEST_PRAGMA.` )
                                            ( ` DATA(obj) = NEW z_class_test( ). "#EC TEST` )
                                            ( ` IF this = 5 AND other <= 2.` )
                                            ( `   obj->instance_meth( ).` )
                                            ( ` ENDIF.` )
                                            ( `ENDMETHOD.` ) ) ) ).
    class_instance->set_methods( methods ).
    instance = new #( class_stamp         = class_instance
                      static_object_calls = abap_false ).
    instance->calculate_metrics( ).
    try.
        data(meths) = class_instance->get_methods( ).
        meth =  meths[ 1 ]-method.
      catch zcx_flow_issue.
      catch cx_sy_itab_line_not_found.
    endtry.
  endmethod.

  method lines_of_code.
    cl_abap_unit_assert=>assert_equals( act = meth->get_lines_of_code( )
                                        exp = 8 ).
  endmethod.

  method number_of_statements.
    cl_abap_unit_assert=>assert_equals( act = meth->get_number_of_statements( )
                                        exp = 7 ).
  endmethod.

  method number_of_comments.
    cl_abap_unit_assert=>assert_equals( act = meth->get_number_of_comments( )
                                        exp = 2 ).
  endmethod.

  method number_of_pragmas.
    cl_abap_unit_assert=>assert_equals( act = meth->get_number_of_pragmas( )
                                        exp = 2 ).
  endmethod.

  method complexity.
    cl_abap_unit_assert=>assert_equals( act = meth->get_complexity_of_conditions( )
                                        exp = 1 ).
  endmethod.

  method complex_weighted.
    cl_abap_unit_assert=>assert_equals( act = meth->get_complex_weighted_by_decisi( )
                                        exp = 2 ).
  endmethod.

  method coupling.
    cl_abap_unit_assert=>assert_equals( act = meth->get_coupling_between_obj( )
                                        exp = 2 ).
  endmethod.

endclass.
