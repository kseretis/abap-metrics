*"* use this source file for your ABAP unit test class
class z_method_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_method.
    methods setup.
    methods get_name for testing.
    methods set_source_code_full for testing raising zcx_flow_issue.
endclass.


class z_method_test implementation.

  method setup.
    instance = new #( name        = 'unit_method'
                      source_code = value #( ( `METHOD unit_method.` )
                                             ( `` )
                                             ( `z_class_test=>call_test_method( ).` )
                                             ( `` )
                                             ( `ENDMETHOD.` ) ) ).
  endmethod.

  method get_name.
    cl_abap_unit_assert=>assert_equals( act = instance->get_name( )
                                        exp = 'unit_method' ).

  endmethod.

  method set_source_code_full.
    cl_abap_unit_assert=>assert_equals( act = instance->get_source_code( )
                                        exp = value rswsourcet( ( `METHOD unit_method.` )
                                                                 ( `` )
                                                                 ( `z_class_test=>call_test_method( ).` )
                                                                 ( `` )
                                                                 ( `ENDMETHOD.` ) ) ).
  endmethod.

endclass.