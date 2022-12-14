*"* use this source file for your ABAP unit test classes
class z_weight_des_calculator_test definition final for testing duration short risk level harmless.

    private section.
      data instance type ref to z_weight_des_calculator.
      methods calculate_1 for testing.
  
  endclass.
  
  
  class z_weight_des_calculator_test implementation.
  
    method calculate_1.
      instance = new #( source_code = value #( ( `METHOD unit_method.` )
                       ( `*  full line comment` )
                       ( `   z_class_test=>call_test_method( ). "in-line comment` )
                       ( `   "com` )
                       ( `   z_class_test=>call_test_method2( ).` )
                        ( `ENDMETHOD.` ) ) ).
  
      cl_abap_unit_assert=>assert_equals( act = instance->calculate( )
                                          exp = 1 ).
    endmethod.
  
  endclass.