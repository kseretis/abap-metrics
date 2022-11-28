class z_class definition public final create public.

  public section.
    types: begin of method_struct,
*             name   type string,
             method type ref to z_method,
           end of method_struct.
    types methods_tab_type type standard table of method_struct with default key.

    methods constructor
      importing name    type string
                package type string.
    methods get_name
      returning value(return) type string.
    methods get_package
      returning value(return) type string.
    methods get_methods
      returning value(return) type methods_tab_type
      raising   zcx_flow_issue.
    methods get_method
      importing name          type string
      returning value(return) type ref to z_method
      raising   zcx_flow_issue.
    methods set_methods
      importing unstructred_methods type z_class_manager=>class_stamp_tab_type.

  protected section.

  private section.
    data name type string.
    data package type string.
    data methods type methods_tab_type.

endclass.

class z_class implementation.

  method constructor.
    me->name = name.
    me->package = package.
  endmethod.

  method get_name.
    return = name.
  endmethod.

  method get_package.
    return = package.
  endmethod.

  method get_methods.
    if methods is initial.
      raise exception new zcx_flow_issue( textid = zcx_flow_issue=>no_methods
                                          value = me->name ).
    endif.
    return = methods.
  endmethod.

  method get_method.
    loop at methods reference into data(meth).
      if name = meth->method->get_name( ).
        return = meth->method.
        return.
      endif.
    endloop.
    raise exception new zcx_flow_issue( textid = zcx_flow_issue=>method_not_found
                                     value = name ).
  endmethod.

  method set_methods.
    loop at unstructred_methods reference into data(meth).
      data(method) = new z_method( name        = conv #( meth->sub_name )
                                   source_code = meth->source ).
      method->set_full_name( meth->sobj_name ).
      insert value #( method = method ) into table methods.
    endloop.
  endmethod.

endclass.