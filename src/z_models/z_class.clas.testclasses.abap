*"* use this source file for your ABAP unit test classes
class z_class_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_class.
    data unstruct_methods type z_class_manager=>class_stamp_tab_type.
    data exp_methods type z_class=>methods_tab_type.

    methods setup.
    methods get_name for testing.
    methods get_package for testing.
    methods set_methods for testing.
    methods get_methods for testing.
    methods get_method for testing.

endclass.

class z_class_test implementation.

  method setup.
    instance = new #( name    = 'Unit_class'
                      package = 'ZUNIT' ).

    data unstruct_method1 type z_class_manager=>class_stamp_struct.
    data unstruct_method2 type z_class_manager=>class_stamp_struct.


    unstruct_method1 = value #( sub_name = 'unit_method1'
                                source = value #( ( `METHOD unit_method1.` )
                                                    ( `` )
                                                    ( `z_class_test=>call_test_method( ).` )
                                                    ( `` )
                                                    ( `ENDMETHOD.` ) ) ).

    unstruct_method2 = value #( sub_name = 'unit_method2'
                                source = value #( ( `METHOD unit_method2.` )
                                                    ( `` )
                                                    ( `z_class_test=>call_test_method( ).` )
                                                    ( `` )
                                                    ( `ENDMETHOD.` ) ) ).

    insert unstruct_method1 into table unstruct_methods.
    insert unstruct_method2 into table unstruct_methods.

    data(method1) = new z_method( name        = 'unit_method1'
                                  source_code = value #( ( `METHOD unit_method1.` )
                                                         ( `` )
                                                         ( `z_class_test=>call_test_method( ).` )
                                                         ( `` )
                                                         ( `ENDMETHOD.` ) ) ).
    data(method2) = new z_method( name        = 'unit_method2'
                                  source_code = value #( ( `METHOD unit_method2.` )
                                                         ( `` )
                                                         ( `z_class_test=>call_test_method( ).` )
                                                         ( `` )
                                                         ( `ENDMETHOD.` ) ) ).

    exp_methods = value #( ( method = method1 )
                           ( method = method2 ) ).
  endmethod.

  method get_name.
    cl_abap_unit_assert=>assert_equals( act = instance->get_name( )
                                        exp = 'Unit_class' ).
  endmethod.

  method get_package.
    cl_abap_unit_assert=>assert_equals( act = instance->get_package( )
                                        exp = 'ZUNIT' ).
  endmethod.

  method set_methods.
    instance->set_methods( unstruct_methods ).
    try.
        data(methods) = instance->get_methods( ).
        cl_abap_unit_assert=>assert_equals( act = methods
                                            exp = exp_methods ).
      catch zcx_flow_issue.
    endtry.
  endmethod.

  method get_methods.
    try.
        instance->set_methods( unstruct_methods ).
        data(methods) = instance->get_methods( ).
        cl_abap_unit_assert=>assert_equals( act = methods
                                            exp = exp_methods ).
      catch zcx_flow_issue.
    endtry.
  endmethod.

  method get_method.
    try.
        instance->set_methods( unstruct_methods ).
        data(exp_method) = exp_methods[ 1 ].
        data(method) = instance->get_method( 'unit_method1' ).
        cl_abap_unit_assert=>assert_equals( act = method
                                            exp = exp_method ).
      catch cx_sy_itab_line_not_found.
      catch zcx_flow_issue.
    endtry.
  endmethod.

endclass.
