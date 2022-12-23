*"* use this source file for your ABAP unit test classes
class z_code_scanner_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_nop_calculator.
    data source_code type rswsourcet .
    methods setup.
    methods get_statements for testing.
    methods get_tokens for testing.
    methods get_source_code for testing.

endclass.


class z_code_scanner_test implementation.

  method setup.
    source_code = value #( ( `METHOD unit_method.` )
                     ( `*  full line comment` )
                     ( `   z_class_test=>call_test_method( ). "in-line comment` )
                     ( `   "com` )
                     ( `   z_class_test=>call_test_method2( ).` )
                      ( `ENDMETHOD.` ) ).
    instance = new #( source_code = source_code ).

  endmethod.

  method get_statements.
    cl_abap_unit_assert=>assert_equals( act = lines( instance->get_statements( ) )
                                        exp = 6 ).
  endmethod.

  method get_tokens.
    cl_abap_unit_assert=>assert_equals( act = lines( instance->get_tokens( ) )
                                        exp = 10 ).
  endmethod.

  method get_source_code.
    cl_abap_unit_assert=>assert_equals( act = instance->get_source_code( )
                                        exp = source_code ).
  endmethod.

endclass.