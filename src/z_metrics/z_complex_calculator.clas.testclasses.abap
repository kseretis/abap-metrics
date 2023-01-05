*"* use this source file for your ABAP unit test classes
class z_complex_calculator_test definition final for testing duration short risk level harmless.

    private section.
      data instance type ref to z_complex_calculator.
      methods calculate_2 for testing.
      methods calculate_zero for testing.

  endclass.

  class z_complex_calculator_test implementation.

    method calculate_2.
      instance = new #( value #( ( `METHOD unit_method.` )
        ( `   if this = 3 and ( other1 = 0 or other2 = 9 ).` )
        ( `       z_class_test=>call_test_method( ). "in-line comment` )
        ( `   endif.` )
        ( `ENDMETHOD.` ) ) ).

      cl_abap_unit_assert=>assert_equals( act = instance->calculate( )
                                          exp = 2 ).
    endmethod.

    method calculate_zero.
      instance = new #( value #( ( `METHOD unit_method.` )
        ( `       z_class_test=>call_test_method( ). ` )
        ( `ENDMETHOD.` ) ) ).

      cl_abap_unit_assert=>assert_equals( act = instance->calculate( )
                                          exp = 0 ).
    endmethod.

  endclass.
