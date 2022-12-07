*"* use this source file for your ABAP unit test classes
class z_code_scanner_test definition final for testing duration short risk level harmless.

  private section.
    data source_code type rswsourcet.
    methods setup.
    methods get_source_code for testing.

endclass.


class z_code_scanner_test implementation.

  method setup.
    source_code = value #( ( `METHOD unit_method.` )
                              ( `` )
                              ( `z_class_test=>call_test_method( ).` )
                              ( `` )
                              ( `ENDMETHOD.` ) ) .
  endmethod.

  method get_source_code.
    data(dummy_instance) = new z_loc_calculator( source_code ).
    cl_abap_unit_assert=>assert_equals( act = dummy_instance->get_source_code( )
                                        exp = source_code ).
  endmethod.

endclass.
