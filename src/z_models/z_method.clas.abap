class z_method definition public final create public inheriting from z_metrics.

  public section.
    methods constructor
      importing name        type string
                source_code type rswsourcet.

    methods get_name
      returning value(return) type string.
    methods get_source_code
      returning value(return) type rswsourcet.

  protected section.

  private section.
    data name type string.
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

endclass.
