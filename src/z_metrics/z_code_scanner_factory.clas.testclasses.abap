*"* use this source file for your ABAP unit test classes
class z_code_scanner_factory_test definition final for testing duration short risk level harmless.

    private section.
      methods setup.
      methods first_test for testing raising cx_static_check.
  endclass.
  
  
  class z_code_scanner_factory_test implementation.
  
    method setup.
      "todo
    endmethod.
  
    method first_test.
      cl_abap_unit_assert=>fail( 'Implement your first test here' ).
    endmethod.
  
  endclass.