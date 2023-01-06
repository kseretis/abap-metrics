*"* use this source file for your ABAP unit test classes
class z_calc_metrics_facade_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_calc_metrics_facade.
    data class_instance type ref to z_class.
    data meth type ref to z_method.

    methods setup.
    methods class_not_found for testing.
    methods number_of_statements for testing.
    methods number_of_comments for testing.
    methods number_of_pragmas for testing.
    methods complexity for testing.
    methods complex_depth for testing.
    methods coupling for testing.
    methods lack_of_cohesion for testing.

endclass.

class z_calc_metrics_facade_test implementation.

  method setup.
    class_instance = new #( name    = 'Unit_class'
                            package = 'ZUNIT' ).

    class_instance->set_methods( value z_class_manager=>class_stamp_tab_type(
                                    ( sub_name = 'unit_method'
                                      source = value #( ( `METHOD unit_method.` )
                                                        ( ` "comment` )
                                                        ( ` z_class_test=>call_test_method( ) ##TEST_PRAGMA.` )
                                                        ( ` DATA(obj) = NEW z_class_test( ). "#EC TEST` )
                                                        ( ` IF this = 5 AND other <= 2.` )
                                                        ( `   obj->instance_meth( ).` )
                                                        ( ` ENDIF.` )
                                                        ( `ENDMETHOD.` ) ) ) ) ).
    try.
        instance = new #( class_stamp         = class_instance
                          static_object_calls = abap_false ).
      catch zcx_metrics_error ##NO_HANDLER.
    endtry.

    instance->calculate_metrics( ).
    try.
        data(meths) = class_instance->get_methods( ).
        meth =  meths[ 1 ]-method.
      catch zcx_flow_issue ##NO_HANDLER.
    endtry.
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

  method complex_depth.
    cl_abap_unit_assert=>assert_equals( act = meth->get_complex_decision_depth( )
                                        exp = 1 ).
  endmethod.

  method coupling.
    cl_abap_unit_assert=>assert_equals( act = meth->get_coupling_between_obj( )
                                        exp = 1 ).
  endmethod.

  method lack_of_cohesion.
    cl_abap_unit_assert=>assert_equals( act = meth->get_lack_of_cohesion( )
                                        exp = 0 ).
  endmethod.

  method class_not_found.
    try.
        new z_calc_metrics_facade( class_stamp = new z_class( name    = 'Unit_class'
                                                              package = 'ZUNIT' )
                                   static_object_calls = abap_false ).
      catch zcx_metrics_error into data(ex).
        cl_abap_unit_assert=>assert_not_initial( act = ex ).
    endtry.
  endmethod.

endclass.
