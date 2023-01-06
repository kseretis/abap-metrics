*"* use this source file for your ABAP unit test classes
class z_authors_calculator_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_authors_calculator.
    methods find_authors for testing raising zcx_metrics_error.
    methods find_authors_error for testing raising zcx_metrics_error.

endclass.

class z_authors_calculator_test implementation.

  method find_authors.
    instance = new #( 'Z_AUTHORS_CALCULATOR          FIND_AUTHORS' ).
    try.
        cl_abap_unit_assert=>assert_equals( act = instance->find_authors( )
                                            exp = 1 ).
      catch zcx_metrics_error ##NO_HANDLER.
    endtry.
  endmethod.

  method find_authors_error.
    instance = new #( 'Z_AUTHORS_CALCULATOR         FIND_AUTHORS2' ).
    try.
        instance->find_authors( ).
      catch zcx_metrics_error into data(ex).
        cl_abap_unit_assert=>assert_not_initial( act = ex ).
    endtry.
  endmethod.

endclass.
