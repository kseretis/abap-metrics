*"* use this source file for your ABAP unit test classes
class z_weight_des_calculator_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_decision_depth_calculator.
    methods calculate_3 for testing.

endclass.


class z_weight_des_calculator_test implementation.

  method calculate_3.
    instance = new #( source_code = value #( ( `METHOD unit_method.` )
                     ( `*  full line comment` )
                     ( `   LOOP AT test_tab INTO DATA(var).` )
                     ( `    IF var = 3.` )
                     ( `        "do` )
                     ( `    ENDIF.` )
                     ( `   ENDLOOP.` )
                     ( `   z_class_test=>call_test_method2( ).` )
                      ( `ENDMETHOD.` ) ) ).

    cl_abap_unit_assert=>assert_equals( act = instance->calculate( )
                                        exp = 3 ).
  endmethod.

endclass.
