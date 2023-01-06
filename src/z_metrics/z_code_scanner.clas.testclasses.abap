*"* use this source file for your ABAP unit test classes
class z_code_scanner_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_nop_calculator.
    data source_code type rswsourcet.
    data instance_clean type ref to z_loc_calculator.
    data instance_clean_only_body type ref to z_loc_calculator.

    methods setup.
    methods get_statements for testing.
    methods get_tokens for testing.
    methods get_source_code for testing.
    methods get_clean_source_code for testing.
    methods get_clean_source_code_body for testing.

endclass.

class z_code_scanner_test implementation.

  method setup.
    source_code = value #( ( `METHOD unit_method.` )
                     ( `*  full line comment` )
                     ( `   z_class_test=>call_test_method( ). "in-line comment` )
                     ( `   "com` )
                     ( `   z_class_test=>call_test_method2( ).` )
                     ( `` )
                      ( `ENDMETHOD.` ) ).
    instance = new #( source_code ).

    instance_clean = new #( source_code ).
    instance_clean->clean_source_code( ).

    instance_clean_only_body = new #( source_code ).
    instance_clean_only_body->clean_source_code( abap_true ).
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

  method get_clean_source_code.
    cl_abap_unit_assert=>assert_equals( act = lines( instance_clean->get_cleaned_source_code( ) )
                                        exp = 4 ).
  endmethod.

  method get_clean_source_code_body.
    cl_abap_unit_assert=>assert_equals( act = lines( instance_clean_only_body->get_cleaned_source_code( ) )
                                        exp = 2 ).
  endmethod.

endclass.
