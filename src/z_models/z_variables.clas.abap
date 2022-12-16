class z_variables definition public final create public.

    public section.
      methods constructor
        importing class_name type seoclsname.
      methods get_attributes
        returning value(return) type table_of_strings.
      methods get_local_variables
        returning value(return) type table_of_strings.
      methods is_attribute
        importing variable      type string
        returning value(return) type abap_bool.
      methods is_local_variable
        importing variable      type string
        returning value(return) type abap_bool.
      methods contains_local_variable
        importing token         type string
        returning value(return) type abap_bool.
      methods append_variable
        importing variable type string.
      methods clear_inline_variable
        importing variable      type string
        returning value(return) type string.
  
    protected section.
  
    private section.
      data class_name type seoclsname.
      data attributes type table_of_strings.
      data local_variables type table_of_strings.
  
      methods fetch_attributes.
  
  endclass.
  
  class z_variables implementation.
  
    method constructor.
      me->class_name = class_name.
      fetch_attributes( ).
    endmethod.
  
    method get_attributes.
      return = attributes.
    endmethod.
  
    method get_local_variables.
      return = attributes.
    endmethod.
  
    method is_attribute.
      return = cond #( when line_exists( attributes[ table_line = variable ] ) then abap_true else abap_false ).
    endmethod.
  
    method is_local_variable.
      return = cond #( when line_exists( local_variables[ table_line = variable ] ) then abap_true else abap_false ).
    endmethod.
  
    method contains_local_variable.
      return = abap_false.
      loop at local_variables assigning field-symbol(<variable>).
        if token cs <variable>.
          return = abap_true.
          exit.
        endif.
      endloop.
    endmethod.
  
    method append_variable.
      insert variable into table local_variables.
    endmethod.
  
    method clear_inline_variable.
      "remove 'DATA(' from token and then ')' from it too
      return = replace( val  = variable
                        sub  = zif_metrics=>local_declaration-in_line_data
                        with = '' ).
      return = replace( val  = return
                        sub  = ')'
                        with = '' ).
    endmethod.
  
    method fetch_attributes.
      try.
          "get class' attributes
          data(tmp_attributes) = cl_oo_class=>get_instance( class_name )->get_attributes( ).
          loop at tmp_attributes assigning field-symbol(<attribute>).
            insert conv #( <attribute>-cmpname ) into table attributes.
          endloop.
        catch cx_class_not_existent.
          "todo
      endtry.
    endmethod.
  
  endclass.