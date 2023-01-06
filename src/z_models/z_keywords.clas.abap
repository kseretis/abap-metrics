class z_keywords definition public final create public.

  public section.
    types: begin of keywords_struct,
             open  type string,
             close type string,
           end of keywords_struct.
    types keywords_tab_type type standard table of keywords_struct.

    methods constructor.
    methods is_keyword
      importing keyword       type string
      returning value(return) type abap_bool.
    methods is_open_keyword
      importing keyword       type string
      returning value(return) type abap_bool.
    methods is_close_keyword
      importing keyword       type string
      returning value(return) type abap_bool.
    methods are_matching
      importing open_keyword  type string
                close_keyword type string
      returning value(return) type abap_bool.
    methods get_close_keyword
      importing open_keyword  type string
      returning value(return) type string
      raising   zcx_metrics_error.

  protected section.

  private section.
    data keywords type keywords_tab_type.

endclass.

class z_keywords implementation.

  method constructor.
    keywords = value #( ( open = 'IF' close = 'ENDIF' )
                        ( open = 'LOOP' close = 'ENDLOOP' )
                        ( open = 'DO' close = 'ENDDO')
                        ( open = 'WHILE' close = 'ENDWHILE' )
                        ( open = 'CASE' close = 'ENDCASE' )
                        ( open = 'TRY' close ='ENDTRY' ) ).
  endmethod.

  method is_keyword.
    return = cond #( when line_exists( keywords[ open = keyword ] ) or line_exists( keywords[ close = keyword ] )
        then abap_true else abap_false ).
  endmethod.

  method is_open_keyword.
    return = cond #( when line_exists( keywords[ open = keyword ] ) then abap_true else abap_false ).
  endmethod.

  method is_close_keyword.
    return = cond #( when line_exists( keywords[ close = keyword ] ) then abap_true else abap_false ).
  endmethod.

  method are_matching.
    return = cond #( when line_exists( keywords[ open = open_keyword close = close_keyword ] )
        then abap_true else abap_false ).
  endmethod.

  method get_close_keyword.
    try.
        return = keywords[ open = open_keyword ]-close.
      catch cx_sy_itab_line_not_found.
        raise exception new zcx_metrics_error( textid = zif_exception_messages=>no_matching_keyword ).
    endtry.
  endmethod.

endclass.
