*"* use this source file for your ABAP unit test classes
class z_nos_calculator_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_nos_calculator.
    methods setup.
    methods calculate for testing.

endclass.

class z_nos_calculator_test implementation.

  method setup.
    instance = new #( value #( ( `METHOD unit_method.` )
      ( `` )
      ( `z_class_test=>call_test_method( ).` )
      ( `` )
      ( `ENDMETHOD.` ) ) ).
  endmethod.

  method calculate.
    cl_abap_unit_assert=>assert_equals( act = instance->calculate( )
                                        exp = 3 ).
  endmethod.

endclass.