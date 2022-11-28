class zcx_metrics_error definition public inheriting from cx_static_check final create public.

  public section.

    interfaces if_t100_dyn_msg.
    interfaces if_t100_message.

    constants:
      begin of empty_version_list,
        msgid type symsgid value 'Z_MESSAGES',
        msgno type symsgno value '003',
        attr1 type scx_attrname value '',
        attr2 type scx_attrname value '',
        attr3 type scx_attrname value '',
        attr4 type scx_attrname value '',
      end of empty_version_list.

    methods constructor
      importing
        !textid   like if_t100_message=>t100key optional
        !previous like previous optional
        !value    type string optional.

    methods display_exception.

  protected section.

  private section.
    data value type i.
endclass.

class zcx_metrics_error implementation.

  method constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).
    clear me->textid.
    if_t100_message~t100key = cond #( when textid is initial then if_t100_message=>default_textid else textid ).
    me->value = value.
  endmethod.

  method display_exception.
    message me->get_text( ) type 'S' display like 'E'.
  endmethod.

endclass.