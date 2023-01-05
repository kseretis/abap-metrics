*"* use this source file for your ABAP unit test classes
class z_authors_calculator_test definition final for testing duration short risk level harmless.

    private section.
      data instance type ref to z_authors_calculator.
      methods find_authors_1 for testing raising zcx_metrics_error.
      methods find_authors_2 for testing raising zcx_metrics_error.
      methods find_authors_3 for testing raising zcx_metrics_error.
      methods find_authors_error for testing raising zcx_metrics_error.

  endclass.

  class z_authors_calculator_test implementation.

    method find_authors_1.
      instance = new #( 'ZCL_UTILITY                   UPLOAD_CSV_TO_ITAB' ).
      try.
          cl_abap_unit_assert=>assert_equals( act = instance->find_authors( )
                                              exp = 1 ).
        catch zcx_metrics_error.
      endtry.
    endmethod.

    method find_authors_2.
      instance = new #( 'ZCL_UTILITY                   TABLE_TO_STRING' ).
      try.
          cl_abap_unit_assert=>assert_equals( act = instance->find_authors( )
                                              exp = 2 ).
        catch zcx_metrics_error.
      endtry.
    endmethod.

    method find_authors_3.
      instance = new #( 'ZCL_UTILITY                   GET_GLOBAL_SET' ).
      try.
          cl_abap_unit_assert=>assert_equals( act = instance->find_authors( )
                                              exp = 3 ).
        catch zcx_metrics_error.
      endtry.
    endmethod.

    method find_authors_error.
      instance = new #( 'ZCL_UTILITY                   TEST_METHOD' ).
      try.
          instance->find_authors( ).
        catch zcx_metrics_error into data(ex).
          cl_abap_unit_assert=>assert_not_initial( act = ex ).
      endtry.
    endmethod.

  endclass.
