*"* use this source file for your ABAP unit test classes
class z_cbo_calculator_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_cbo_calculator.
    methods calculate_no_static for testing.
    methods calculate_with_static for testing.

endclass.

class z_cbo_calculator_test implementation.

  method calculate_no_static.
    instance = new #( source_code         = value #( ( `METHOD unit_method.` )
                                                 ( `` )
                                                 ( `z_class_test=>call_test_method( ).` )
                                                 ( `DATA(obj) = NEW z_instance_class( ).` )
                                                 ( `obj->instance_method( ).` )
                                                 ( `` )
                                                 ( `ENDMETHOD.` ) )
                      static_object_calls = abap_false ).

    cl_abap_unit_assert=>assert_equals( act = instance->calculate( )
                                        exp = 1 ).
  endmethod.

  method calculate_with_static.
    instance = new #( source_code         = value #( ( `METHOD unit_method.` )
                                                 ( `` )
                                                 ( `z_class_test=>call_test_method( ).` )
                                                 ( `DATA(obj) = NEW z_instance_class( ).` )
                                                 ( `obj->instance_method( ).` )
                                                 ( `` )
                                                 ( `ENDMETHOD.` ) )
                      static_object_calls = abap_true ).

    cl_abap_unit_assert=>assert_equals( act = instance->calculate( )
                                        exp = 2 ).
  endmethod.

endclass.
