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
  
    protected section.
  
    private section.
      data keywords type keywords_tab_type.
  
  endclass.
  
  class z_keywords implementation.
  
    method constructor.
      "TODO add keywords
      keywords = value #( ( open = 'IF' close = 'ENDIF') ).
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
  
  endclass.