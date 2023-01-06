class z_variables definition public final create public.

  public section.
    types: begin of parameters_struct,
             parameter_name type string,
             method_name    type string,
           end of parameters_struct.

    methods constructor
      importing class_name type seoclsname
      raising   zcx_metrics_error.
    methods get_attributes
      returning value(return) type table_of_strings.
    methods get_local_variables
      returning value(return) type table_of_strings.
    methods get_parameters
      returning value(return) type table_of_strings.
    methods get_merged_variables
      returning value(return) type table_of_strings.
    methods is_attribute
      importing variable      type string
      returning value(return) type abap_bool.
    methods is_local_variable
      importing variable      type string
      returning value(return) type abap_bool.
    methods is_parameter
      importing method_name   type string
                variable      type string
      returning value(return) type abap_bool.
    methods contains_variable
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
    data parameters type standard table of parameters_struct.
    data local_variables type table_of_strings.

    methods fetch_attributes
      raising zcx_metrics_error.
    methods fetch_parameters
      raising zcx_metrics_error.
    methods remove_characters
      importing variable      type string
                character     type string
      returning value(return) type string.
endclass.

class z_variables implementation.

  method constructor.
    me->class_name = class_name.
    fetch_attributes( ).
    fetch_parameters( ).
  endmethod.

  method get_attributes.
    return = attributes.
  endmethod.

  method get_local_variables.
    return = local_variables.
  endmethod.

  method get_parameters.
    return = value #( for i in parameters ( i-parameter_name ) ).
  endmethod.

  method get_merged_variables.
    return = value #( for i in parameters ( i-parameter_name ) ).
    return = value #( base return ( lines of attributes )
                                  ( lines of local_variables ) ).
    sort return ascending.
    delete adjacent duplicates from return.
  endmethod.

  method is_attribute.
    data(tmp_variable) = cond #( when variable cs zif_metrics=>this
                                    then substring_after( val = variable
                                                          sub = zif_metrics=>this )
                                    else variable ).
    return = cond #( when line_exists( attributes[ table_line = tmp_variable ] ) then abap_true else abap_false ).
  endmethod.

  method is_local_variable.
    return = cond #( when line_exists( local_variables[ table_line = variable ] ) then abap_true else abap_false ).
  endmethod.

  method is_parameter.
    return = cond #( when line_exists( parameters[ method_name = method_name parameter_name = variable ] )
                        then abap_true else abap_false ).
  endmethod.

  method contains_variable.
    "check the merged table if contains the token passed
    return = abap_false.
    loop at get_merged_variables( ) assigning field-symbol(<variable>).
      if token cs |({ <variable> })| or token cs |@{ <variable> }|
        or token cs |{ <variable> }-| or token cs |{ <variable> }+| .
        return = abap_true.
        exit.
      endif.
    endloop.
  endmethod.

  method append_variable.
    insert variable into table local_variables.
  endmethod.

  method clear_inline_variable.
    "remove unnecessary characters from string
    if variable cs zif_metrics=>local_declaration-field_symbol.
      return = remove_characters( variable  = variable
                                  character = zif_metrics=>local_declaration-field_symbols ).
      return = remove_characters( variable  = return
                                  character = zif_metrics=>local_declaration-field_symbol ).
      return = remove_characters( variable  = return
                                  character = zif_metrics=>symbols-parenthesis_open ).
      return = remove_characters( variable  = return
                                  character = zif_metrics=>symbols-parenthesis_close ).
    elseif variable cs zif_metrics=>local_declaration-data.
      return = remove_characters( variable  = variable
                                  character = zif_metrics=>local_declaration-data ).
      return = remove_characters( variable  = return
                                  character = zif_metrics=>symbols-parenthesis_open ).
      return = remove_characters( variable  = return
                                  character = zif_metrics=>symbols-parenthesis_close ).
      return = remove_characters( variable  = return
                                  character = zif_metrics=>symbols-at ).
    elseif variable cs zif_metrics=>symbols-dash.
      return = substring_before( val = variable
                                 sub = zif_metrics=>symbols-dash ).
    elseif variable cs zif_metrics=>symbols-at.
      return = substring_after( val = variable
                                sub = zif_metrics=>symbols-at ).
    endif.
  endmethod.

  method remove_characters.
    return = replace( val  = variable
                      sub  = character
                      with = zif_metrics=>symbols-blank ).
  endmethod.

  method fetch_attributes.
    try.
        "get class' attributes
        attributes = value #( for a in cl_oo_class=>get_instance( class_name )->get_attributes( ) ( conv #( a-cmpname ) ) ).
      catch cx_class_not_existent.
        raise exception new zcx_metrics_error( textid = zif_exception_messages=>no_class_found
                                               value = conv #( class_name ) ).
    endtry.
  endmethod.

  method fetch_parameters.
    try.
        "get methods' parameters
        parameters = value #( for a in cl_oo_class=>get_instance( class_name )->method_parameters
                                ( parameter_name = conv #( a-sconame )
                                  method_name = conv #( a-cmpname ) ) ).
      catch cx_class_not_existent ##NO_HANDLER.
    endtry.
  endmethod.

endclass.
