class z_method definition public final create public inheriting from z_metrics.

  public section.
    types full_name_type(110) type c.

    methods constructor
      importing name        type string
                source_code type rswsourcet.
    methods get_name
      returning value(return) type string.
    methods get_source_code
      returning value(return) type rswsourcet.
    methods get_full_name
      returning value(return) type string.
    methods set_full_name
      importing full_name type full_name_type.

  protected section.

  private section.
    data name type string.
    data full_name type full_name_type.
    data source_code type rswsourcet.

endclass.

class z_method implementation.

  method constructor.
    super->constructor( ).
    me->name = name.
    me->source_code = source_code.
  endmethod.

  method get_name.
    return = name.
  endmethod.

  method get_source_code.
    return = source_code.
  endmethod.

  method get_full_name.
    return = full_name.
  endmethod.

  method set_full_name.
    me->full_name = full_name.
  endmethod.

endclass.