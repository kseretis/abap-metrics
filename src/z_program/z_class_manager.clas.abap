class z_class_manager definition public final create private.

  public section.
    types:
      begin of class_stamp_struct,
        devclass     type devclass,
        object       type trobjtype,
        obj_name(61) type c,
        subc         type trdir-subc,
        sub_type     type trobjtype,
        sub_name(61) type c,
        sobj_name    type versobjnam,
        genflag      type genflag,
        author       type responsibl,
        changer      type responsibl,
        source       type rswsourcet,
      end of class_stamp_struct.
    types class_stamp_tab_type type standard table of class_stamp_struct with default key.
    types memory_id_type(60) type c.

    constants c_prefix type string value 'CLASS'.

    class-methods export_to_memory
      importing class_stamp type class_stamp_tab_type.

    class-methods import_from_memory
      importing class_stamp_id type memory_id_type
      returning value(return)  type class_stamp_tab_type.


  protected section.

  private section.
    class-data memory_id type memory_id_type.

    class-methods is_exported
      returning value(return) type abap_bool.
    class-methods set_memory_id
      importing class_stamp type class_stamp_tab_type.

endclass.

class z_class_manager implementation.

  method export_to_memory.
    set_memory_id( class_stamp ).
    if not is_exported( ).
      export exporting_object from class_stamp to memory id memory_id.
    endif.
  endmethod.

  method import_from_memory.
    import exporting_object to return from memory id class_stamp_id.
  endmethod.

  method is_exported.
    data existing_in_memory type class_stamp_tab_type.
    import exporting_object to existing_in_memory from memory id memory_id.
    return = cond #( when sy-subrc = 0 then abap_true else abap_false ).
  endmethod.

  method set_memory_id.
    try.
        memory_id = |{ c_prefix }_{ class_stamp[ 1 ]-obj_name }|.
      catch cx_sy_itab_line_not_found.
    endtry.
  endmethod.

endclass.
