*"* use this source file for your ABAP unit test classes
class z_cohesion_calculator_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_cohesion_calculator.
    methods calc_local_declaration for testing raising zcx_metrics_error.
    methods calc_method_calls for testing raising zcx_metrics_error.
    methods calc_nested_keywords for testing raising zcx_metrics_error.
    methods calc_this for testing raising zcx_metrics_error.
    methods calc_class_not_found for testing raising zcx_metrics_error.

endclass.

class z_cohesion_calculator_test implementation..

  method calc_local_declaration.
    try.
        instance = new #( source_code = value #( ( `  method test_local_declaration.` )
                                                     ( `     data test_var3 type i. ` )
                                                     ( `     ` )
                                                     ( `     data(test_var4) = abap_false.   ` )
                                                     ( `     if test_var4 = abap_false.  ` )
                                                     ( `       test_var3 = 3.    ` )
                                                     ( `     endif.  ` )
                                                     ( `  endmethod.` ) )
                          class_name  = 'ZCL_TEST_LCOM'
                          method_name = 'TEST_METHOD' ).
        cl_abap_unit_assert=>assert_equals( exp = 4
                                            act = instance->calculate( ) ).
      catch zcx_metrics_error.
    endtry.
  endmethod.

  method calc_method_calls.
    try.
        instance = new #( source_code = value #( ( `   method test_method_calls. ` )
                                                     ( `     salv->get_columns( )->set_optimize( ` )
                                                     ( `                                 value = abap_true ).    ` )
                                                     ( `     try.    ` )
                                                     ( `         data(col) = salv->get_columns( )->get_column( columnname = 'MATNR' ).   ` )
                                                     ( `         col->set_long_text( 'teeeext' ).    ` )
                                                     ( `       catch cx_salv_not_found.  ` )
                                                     ( `     endtry. ` )
                                                     ( `     salv->display( ).   ` )
                                                     ( `   endmethod.    ` ) )
                          class_name  = 'ZCL_TEST_LCOM'
                          method_name = 'TEST_METHOD' ).
        cl_abap_unit_assert=>assert_equals( exp = 14
                                            act = instance->calculate( ) ).
      catch zcx_metrics_error.
    endtry.
  endmethod.

  method calc_nested_keywords.
    try.
        instance = new #( source_code = value #( ( `      method test_nested_keywords.  ` )
                                                    ( `     if one = 4. ` )
                                                    ( `       if two = 3.   ` )
                                                    ( `         if three = 0.   ` )
                                                    ( `           do 3 times.   ` )
                                                    ( `             if one = 1. ` )
                                                    ( `               one = 10. ` )
                                                    ( `             endif.  ` )
                                                    ( `           enddo.    ` )
                                                    ( `         endif.  ` )
                                                    ( `         loop at mara_tab reference into data(ref).  ` )
                                                    ( `           ref->matnr = 'dasd'.  ` )
                                                    ( `         endloop.    ` )
                                                    ( `         two = 13.   ` )
                                                    ( `       endif.    ` )
                                                    ( `     endif.  ` )
                                                    ( `   endmethod.    ` ) )
                          class_name  = 'ZCL_TEST_LCOM'
                          method_name = 'TEST_METHOD' ).
        cl_abap_unit_assert=>assert_equals( exp = 83
                                            act = instance->calculate( ) ).
      catch zcx_metrics_error.
    endtry.
  endmethod.

  method calc_this.
    try.
        instance = new #( source_code = value #( ( `      method test_this. ` )
                                                    ( `     one = 10.   ` )
                                                    ( `     ` )
                                                    ( `     if three > two. ` )
                                                    ( `       two = 2.  ` )
                                                    ( `       one = 1.  ` )
                                                    ( `     endif.  ` )
                                                    ( `   endmethod.    ` ) )
                          class_name  = 'ZCL_TEST_LCOM'
                          method_name = 'TEST_METHOD' ).
        cl_abap_unit_assert=>assert_equals( exp = 4
                                            act = instance->calculate( ) ).
      catch zcx_metrics_error.
    endtry.
  endmethod.

  method calc_class_not_found.
    try.
        instance = new #( source_code = value #( ( `      method test_this. ` )
                                                ( `     one = 10.   ` )
                                                ( `     ` )
                                                ( `     if three > two. ` )
                                                ( `       two = 2.  ` )
                                                ( `       one = 1.  ` )
                                                ( `     endif.  ` )
                                                ( `   endmethod.    ` ) )
                          class_name  = 'ZCL_TEST'
                          method_name = 'TEST_METHOD' ).
      catch zcx_metrics_error into data(ex).
        cl_abap_unit_assert=>assert_not_initial( ex ).
    endtry.
  endmethod.

endclass.
