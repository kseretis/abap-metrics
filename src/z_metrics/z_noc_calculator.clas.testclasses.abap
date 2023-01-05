*"* use this source file for your ABAP unit test classes
class z_noc_calculator_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_noc_calculator.
    methods calculate_1 for testing.
    methods calculate_2 for testing.
    methods calculate_3 for testing.

endclass.

class z_noc_calculator_test implementation.

  method calculate_1.
    instance = new #( value #( ( `METHOD unit_method.` )
      ( `` )
      ( `z_class_test=>call_test_method( ). "comment` )
      ( `ENDMETHOD.` ) ) ).
    cl_abap_unit_assert=>assert_equals( act = instance->calculate( )
                                        exp = 1 ).
  endmethod.

  method calculate_2.
    instance = new #( value #( ( `METHOD unit_method.` )
      ( `*comment` )
      ( `z_class_test=>call_test_method( ). "comment` )
      ( `ENDMETHOD.` ) ) ).
    cl_abap_unit_assert=>assert_equals( act = instance->calculate( )
                                        exp = 2 ).
  endmethod.

  method calculate_3.
    instance = new #( value #( ( `METHOD unit_method.` )
      ( `*comment` )
      ( `z_class_test=>call_test_method( ). "comment` )
      ( `z_class_test=>call_test_method( ) "#comment.` )
      ( `ENDMETHOD.` ) ) ).
    cl_abap_unit_assert=>assert_equals( act = instance->calculate( )
                                        exp = 3 ).
  endmethod.

endclass.
