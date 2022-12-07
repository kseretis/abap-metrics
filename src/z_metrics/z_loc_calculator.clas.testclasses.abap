*"* use this source file for your ABAP unit test classes
class z_loc_calculator_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_loc_calculator.
    methods setup.
    methods get_tokens for testing.
    methods get_statements for testing.
    methods check_calculation for testing.
endclass.


class z_loc_calculator_test implementation.

  method setup.
    instance = new #( value #( ( `METHOD unit_method.` )
                                  ( `` )
                                  ( `z_class_test=>call_test_method( ).` )
                                  ( `` )
                                  ( `ENDMETHOD.` ) ) ).
  endmethod.

  method get_tokens.
    cl_abap_unit_assert=>assert_equals( act = lines( instance->get_tokens( ) )
                                        exp = 0 ).
  endmethod.

  method get_statements.
    cl_abap_unit_assert=>assert_equals( act = lines( instance->get_statements( ) )
                                        exp = 0 ).
  endmethod.

  method check_calculation.
    data(calc) = instance->calculate( ).
    cl_abap_unit_assert=>assert_equals( act = calc
                                        exp = 5 ).
  endmethod.

endclass.
