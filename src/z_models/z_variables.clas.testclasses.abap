*"* use this source file for your ABAP unit test classes
class z_variables_test definition final for testing duration short risk level harmless.

    private section.
      data instance type ref to z_variables.
      methods setup.
      methods get_attributes for testing.
      methods get_local_variables for testing.
      methods get_parameters for testing.
      methods get_merged_vars for testing.
      methods append_local_var for testing.
      methods is_attribute for testing.
      methods is_parameter for testing.
      methods is_local_var for testing.
      methods contain_variable for testing.
      methods clear_inline_variable_data for testing.
      methods clear_inline_variable_fs for testing.
  
  endclass.
  
  class z_variables_test implementation.
  
    method setup.
      try.
          instance = new #( 'CL_SALV_TABLE' ).
        catch zcx_metrics_error ##NO_HANDLER.
      endtry.
    endmethod.
  
    method get_attributes.
      cl_abap_unit_assert=>assert_not_initial( act = instance->get_attributes( ) ).
    endmethod.
  
    method get_local_variables.
      instance->append_variable( 'local_var' ).
      cl_abap_unit_assert=>assert_not_initial( act = instance->get_local_variables( ) ).
    endmethod.
  
    method get_parameters.
      cl_abap_unit_assert=>assert_not_initial( act = instance->get_parameters( ) ).
    endmethod.
  
    method get_merged_vars.
      data(attr) = instance->get_attributes( ).
      cl_abap_unit_assert=>assert_table_contains( table = instance->get_merged_variables( )
                                                  line  = attr[ 1 ] ).
    endmethod.
  
    method append_local_var.
      data(var) = `LOCAL_VAR`.
      instance->append_variable( var ).
      cl_abap_unit_assert=>assert_table_contains( table = instance->get_local_variables( )
                                                  line  = var ).
    endmethod.
  
    method is_attribute.
      cl_abap_unit_assert=>assert_true( act = instance->is_attribute( 'R_COLUMNS' ) ).
    endmethod.
  
    method is_parameter.
      cl_abap_unit_assert=>assert_true( act = instance->is_parameter( method_name = 'FACTORY'
                                                                      variable = 'T_TABLE' ) ).
    endmethod.
  
    method is_local_var.
      instance->append_variable( 'LOCAL_VAR' ).
      cl_abap_unit_assert=>assert_true( act = instance->is_local_variable( 'LOCAL_VAR' ) ).
    endmethod.
  
    method contain_variable.
      instance->append_variable( 'LOCAL_VAR' ).
      cl_abap_unit_assert=>assert_true( act = instance->contains_variable( 'LOCAL_VAR-FIELD' ) ).
    endmethod.
  
    method clear_inline_variable_data.
      cl_abap_unit_assert=>assert_equals( act = instance->clear_inline_variable( '@DATA(TEST)' )
                                          exp = 'TEST' ).
    endmethod.
  
    method clear_inline_variable_fs.
      cl_abap_unit_assert=>assert_equals( act = instance->clear_inline_variable( 'FIELD-SYMBOL(<UNIT>)' )
                                          exp = '<UNIT>' ).
    endmethod.
  
  endclass.