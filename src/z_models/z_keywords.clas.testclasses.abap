*"* use this source file for your ABAP unit test classes
class z_keywords_test definition final for testing  duration short  risk level harmless.

  private section.
    data instance type ref to z_keywords.
    methods setup.
    methods is_keyword_true for testing.
    methods is_keyword_false for testing.
    methods is_open_keyword_true for testing.
    methods is_open_keyword_false for testing.
    methods is_close_keyword_true for testing.
    methods is_close_keyword_false for testing.
    methods are_matching_true for testing.
    methods are_matching_false for testing.
    methods get_close_keyword_true for testing raising zcx_metrics_error.
    methods get_close_keyword_false for testing raising zcx_metrics_error.

endclass.

class z_keywords_test implementation.

  method setup.
    instance = new #( ).
  endmethod.

  method is_keyword_true.
    cl_abap_unit_assert=>assert_true( instance->is_keyword( 'IF' ) ).
  endmethod.

  method is_keyword_false.
    cl_abap_unit_assert=>assert_false( instance->is_keyword( 'NOIF' ) ).
  endmethod.

  method is_open_keyword_true.
    cl_abap_unit_assert=>assert_true( instance->is_open_keyword( 'IF' ) ).
  endmethod.

  method is_open_keyword_false.
    cl_abap_unit_assert=>assert_false( instance->is_close_keyword( 'ENDI' ) ).
  endmethod.

  method is_close_keyword_true.
    cl_abap_unit_assert=>assert_true( instance->is_close_keyword( 'ENDLOOP' ) ).
  endmethod.

  method is_close_keyword_false.
    cl_abap_unit_assert=>assert_false( instance->is_close_keyword( 'LOOP' ) ).
  endmethod.

  method are_matching_true.
    cl_abap_unit_assert=>assert_true( instance->are_matching( open_keyword = 'DO'
                                                              close_keyword = 'ENDDO' ) ).
  endmethod.

  method are_matching_false.
    cl_abap_unit_assert=>assert_false( instance->are_matching( open_keyword = 'DO'
                                                              close_keyword = 'ENDLOOP' ) ).
  endmethod.

  method get_close_keyword_true.
    cl_abap_unit_assert=>assert_equals( act = instance->get_close_keyword( 'IF' )
                                        exp = 'ENDIF' ).
  endmethod.

  method get_close_keyword_false.
    try.
        data(ret) = instance->get_close_keyword( 'NIF' ).
      catch zcx_metrics_error.
        cl_abap_unit_assert=>assert_initial( act = ret ).
    endtry.
  endmethod.

endclass.
