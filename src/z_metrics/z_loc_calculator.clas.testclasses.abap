*"* use this source file for your ABAP unit test classes
class z_loc_calculator_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_loc_calculator.
    methods calculate_3 for testing.
    methods calculate_4 for testing.

endclass.


class z_loc_calculator_test implementation.

  method calculate_3.
    instance = new #( value #( ( `METHOD unit_method.` )
      ( `   z_class_test=>call_test_method( ). "in-line comment` )
      ( `ENDMETHOD.` ) ) ).

    cl_abap_unit_assert=>assert_equals( act = instance->calculate( )
                                        exp = 3 ).
  endmethod.

  method calculate_4.
    instance = new #( value #( ( `METHOD unit_method.` )
      ( `*  full line comment` )
      ( `   z_class_test=>call_test_method( ). "` )
      ( `   "com` )
      ( `   z_class_test=>call_test_method2( ).` )
      ( `ENDMETHOD.` ) ) ).

    cl_abap_unit_assert=>assert_equals( act = instance->calculate( )
                                        exp = 4 ).
  endmethod.

endclass.