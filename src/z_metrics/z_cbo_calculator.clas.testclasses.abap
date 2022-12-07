*"* use this source file for your ABAP unit test classes
class z_cbo_calculator_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_cbo_calculator.
    methods setup.
    methods get_tokens for testing.
    methods get_statements for testing.
    methods check_calculate for testing.

endclass.

class z_cbo_calculator_test implementation.

  method setup.
    instance = new #( source_code         = value #( ( `METHOD unit_method.` )
                                                 ( `` )
                                                 ( `z_class_test=>call_test_method( ).` )
                                                 ( `DATA(obj) = NEW z_instance_class( ).` )
                                                 ( `obj->instance_method( ).` )
                                                 ( `` )
                                                 ( `ENDMETHOD.` ) )
                      static_object_calls = abap_false ).
  endmethod.

  method get_tokens.
    cl_abap_unit_assert=>assert_equals( act = lines( instance->get_tokens( ) )
                                        exp = 12 ).
  endmethod.

  method get_statements.
    cl_abap_unit_assert=>assert_equals( act = lines( instance->get_statements( ) )
                                        exp = 5 ).
  endmethod.

  method check_calculate.
    data(cbo) = instance->calculate( ).
    cl_abap_unit_assert=>assert_equals( act = cbo
                                        exp = 2 ).
  endmethod.

endclass.
