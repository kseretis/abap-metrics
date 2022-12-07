class z_metrics definition public create public.

  public section.

    methods get_lines_of_code
      returning value(return) type i.
    methods set_lines_of_code
      importing value type i.

    methods get_number_of_comments
      returning value(return) type i.
    methods set_number_of_comments
      importing value type i.

    methods get_number_of_statements
      returning value(return) type i.
    methods set_number_of_statements
      importing value type i.

    methods get_number_of_pragmas
      returning value(return) type i.
    methods set_number_of_pragmas
      importing value type i.

    methods get_complexity_of_conditions
      returning value(return) type i.
    methods set_complexity_of_conditions
      importing value type i.

    methods get_number_of_authors
      returning value(return) type i.
    methods set_number_of_authors
      importing value type i.

    methods get_complex_weighted_by_decisi
      returning value(return) type i.
    methods set_complex_weighted_by_decisi
      importing value type i.

    methods get_coupling_between_obj
      returning value(return) type i.
    methods set_coupling_between_obj
      importing value type i.

    methods get_lack_of_cohesion
      returning value(return) type i.
    methods set_lack_of_cohision
      importing value type i.

  protected section.

  private section.
    data lines_of_code type i.
    data number_of_comments type i.
    data number_of_statements type i.
    data number_of_pragmas type i.
    data complexity_of_conditions type i.
    data number_of_authors type i.
    data complex_weighted_by_decision type i.
    data lack_of_cohesion type i.
    data coupling_between_object type i.

endclass.

class z_metrics implementation.

  method get_lines_of_code.
    return = lines_of_code.
  endmethod.

  method set_lines_of_code.
    me->lines_of_code = value.
  endmethod.

  method get_number_of_comments.
    return = number_of_comments.
  endmethod.

  method set_number_of_comments.
    me->number_of_comments = value.
  endmethod.

  method get_number_of_statements.
    return = number_of_statements.
  endmethod.

  method set_number_of_statements.
    me->number_of_statements = value.
  endmethod.

  method get_number_of_pragmas.
    return = number_of_pragmas.
  endmethod.

  method set_number_of_pragmas.
    me->number_of_pragmas = value.
  endmethod.

  method get_complexity_of_conditions.
    return = complexity_of_conditions.
  endmethod.

  method set_complexity_of_conditions.
    me->complexity_of_conditions = value.
  endmethod.

  method get_number_of_authors.
    return = number_of_authors.
  endmethod.

  method set_number_of_authors.
    me->number_of_authors = value.
  endmethod.

  method get_complex_weighted_by_decisi.
    return = complex_weighted_by_decision.
  endmethod.

  method set_complex_weighted_by_decisi.
    me->complex_weighted_by_decision = value.
  endmethod.

  method get_coupling_between_obj.
    return = coupling_between_object.
  endmethod.

  method set_coupling_between_obj.
    me->coupling_between_object = value.
  endmethod.

  method get_lack_of_cohesion.
    return = lack_of_cohesion.
  endmethod.

  method set_lack_of_cohision.
    me->lack_of_cohesion = value.
  endmethod.

endclass.
