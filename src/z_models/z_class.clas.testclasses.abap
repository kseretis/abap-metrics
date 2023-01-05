*"* use this source file for your ABAP unit test classes
class z_class_test definition final for testing duration short risk level harmless.

  private section.
    data instance type ref to z_class.
    data unstruct_methods type z_class_manager=>class_stamp_tab_type.
    data exp_methods type z_class=>methods_tab_type.
    data method1 type ref to z_method.
    data method2 type ref to z_method.

    methods setup.
    methods get_name for testing.
    methods get_package for testing.
    methods get_methods for testing.
    methods get_method for testing.

endclass.

class z_class_test implementation.

  method setup.
    instance = new #( name    = 'Unit_class'
                      package = 'ZUNIT' ).

    unstruct_methods = value #( ( sub_name = 'unit_method1'
                                  source = value #( ( `METHOD unit_method1.` )
                                                    ( `` )
                                                    ( `z_class_test=>call_test_method( ).` )
                                                    ( `` )
                                                    ( `ENDMETHOD.` ) ) )
                                ( sub_name = 'unit_method2'
                                  source = value #( ( `METHOD unit_method2.` )
                                                    ( `` )
                                                    ( `z_class_test=>call_test_method( ).` )
                                                    ( `` )
                                                    ( `ENDMETHOD.` ) ) ) ).

    instance->set_methods( unstruct_methods ).

    method1 = new z_method( name        = 'unit_method1'
                            source_code = corresponding #( unstruct_methods[ 1 ]-source ) ).

    method2 = new z_method( name        = 'unit_method2'
                            source_code = corresponding #( unstruct_methods[ 2 ]-source ) ).

    exp_methods = value #( ( name = method1->get_name( )
                             method = method1 )
                           ( name = method2->get_name( )
                             method = method2 ) ).
  endmethod.

  method get_name.
    cl_abap_unit_assert=>assert_equals( act = instance->get_name( )
                                        exp = 'Unit_class' ).
  endmethod.

  method get_package.
    cl_abap_unit_assert=>assert_equals( act = instance->get_package( )
                                        exp = 'ZUNIT' ).
  endmethod.

  method get_methods.
    try.
        instance->set_methods( unstruct_methods ).
        data(meths) = instance->get_methods( ).
        cl_abap_unit_assert=>assert_equals( act = meths[ 2 ]-method->get_name( )
                                            exp = method2->get_name( ) ).
      catch zcx_flow_issue ##NO_HANDLER.
    endtry.
  endmethod.

  method get_method.
    try.
        cl_abap_unit_assert=>assert_equals( act = instance->get_method( 'unit_method1' )->get_name( )
                                            exp = exp_methods[ 1 ]-method->get_name( ) ).
      catch zcx_flow_issue ##NO_HANDLER.
    endtry.
  endmethod.

endclass.