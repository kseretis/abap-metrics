*"* use this source file for your ABAP unit test classes
class z_metrics_test definition final for testing duration short risk level harmless.

    private section.
      data instance type ref to z_metrics.
      methods setup.
      methods get_lines_of_code for testing.
      methods get_number_of_comments for testing.
      methods get_number_of_statements for testing.
      methods get_number_of_pragmas for testing.
      methods get_complexity_of_conditions for testing.
      methods get_number_of_authors for testing.
      methods get_complex_decision_depth for testing.
      methods get_coupling_between_obj for testing.
      methods get_lack_of_cohesion for testing.
  
  endclass.
  
  class z_metrics_test implementation.
  
    method setup.
      instance = new #( ).
    endmethod.
  
    method get_lines_of_code.
      instance->set_lines_of_code( 14 ).
      cl_abap_unit_assert=>assert_equals( act = instance->get_lines_of_code( )
                                          exp = 14 ).
    endmethod.
  
    method get_number_of_comments.
      instance->set_number_of_comments( 11 ).
      cl_abap_unit_assert=>assert_equals( act = instance->get_number_of_comments( )
                                          exp = 11 ).
    endmethod.
  
    method get_number_of_statements.
      instance->set_number_of_statements( 345 ).
      cl_abap_unit_assert=>assert_equals( act = instance->get_number_of_statements( )
                                          exp = 345 ).
    endmethod.
  
    method get_number_of_pragmas.
      instance->set_number_of_pragmas( 3 ).
      cl_abap_unit_assert=>assert_equals( act = instance->get_number_of_pragmas( )
                                          exp = 3 ).
    endmethod.
  
    method get_complexity_of_conditions.
      instance->set_complexity_of_conditions( 6 ).
      cl_abap_unit_assert=>assert_equals( act = instance->get_complexity_of_conditions( )
                                          exp = 6 ).
    endmethod.
  
    method get_number_of_authors.
      instance->set_number_of_authors( 1 ).
      cl_abap_unit_assert=>assert_equals( act = instance->get_number_of_authors( )
                                          exp = 1 ).
    endmethod.
  
    method get_complex_decision_depth.
      instance->set_complex_decision_depth( 8 ).
      cl_abap_unit_assert=>assert_equals( act = instance->get_complex_decision_depth( )
                                          exp = 8 ).
    endmethod.
  
    method get_coupling_between_obj.
      instance->set_coupling_between_obj( 32 ).
      cl_abap_unit_assert=>assert_equals( act = instance->get_coupling_between_obj( )
                                          exp = 32 ).
    endmethod.
  
    method get_lack_of_cohesion.
      instance->set_lack_of_cohision( 650 ).
      cl_abap_unit_assert=>assert_equals( act = instance->get_lack_of_cohesion( )
                                          exp = 650 ).
    endmethod.
  
  endclass.