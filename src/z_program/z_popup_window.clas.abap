class z_popup_window definition public final create public.

  public section.
    types: begin of message_struct,
             object(30)  type c,
             message(50) type c,
           end of message_struct .

    methods add_message
      importing message type message_struct.
    methods build_display.
    methods display_popup.
    methods has_messages
      returning value(return) type abap_bool.
    methods get_answer
      returning value(return) type abap_bool.

  protected section.

  private section.
    data output type ref to cl_salv_table .
    data messages type standard table of message_struct.
    data answer type abap_bool value abap_true.

    methods on_click_handler
      for event if_salv_events_functions~added_function of cl_salv_events_table
      importing e_salv_function .
    methods set_screen_status.
    methods set_screen_popup.

endclass.

class z_popup_window implementation.

  method add_message.
    insert message into table messages.
  endmethod.

  method build_display.
    try.
        cl_salv_table=>factory(
          importing
            r_salv_table = output
          changing
            t_table      = messages ).
        "change columns' labels
        output->get_columns( )->get_column( 'OBJECT' )->set_long_text( zif_popup_window=>labels-object ).
        output->get_columns( )->get_column( 'MESSAGE' )->set_long_text( zif_popup_window=>labels-message ).
      catch cx_salv_msg ##NO_HANDLER.
      catch cx_salv_not_found ##NO_HANDLER.
    endtry.

    "set title
    output->get_display_settings( )->set_list_header( zif_popup_window=>title ).

    "set header text
    data(header) = new cl_salv_form_layout_grid( ).
    data(header_text) = header->create_label( row = 1 column = 1 ).
    header_text->set_text( zif_popup_window=>header ).

    "set footer text
    data(footer) = new cl_salv_form_layout_grid( ).
    data(footer_text) = footer->create_label( row = 1 column = 1 ).
    footer_text->set_text( zif_popup_window=>footer ).

    output->set_top_of_list( header ).
    output->set_end_of_list( footer ).

    "optimize
    output->get_columns( )->set_optimize( abap_true ).

    "set handler
    set handler on_click_handler for output->get_event( ).

    set_screen_status( ).
    set_screen_popup( ).
  endmethod.

  method display_popup.
    output->display( ).
  endmethod.

  method has_messages.
    return = cond #( when messages is initial then abap_false else abap_true ).
  endmethod.

  method on_click_handler.
    case e_salv_function.
      when zif_popup_window=>answers-yes.
        output->close_screen( ).
        answer = abap_true.
      when zif_popup_window=>answers-no.
        output->close_screen( ).
        answer = abap_false.
    endcase.
  endmethod.

  method get_answer.
    return = answer.
  endmethod.

  method set_screen_popup.
    output->set_screen_popup( start_column = zif_popup_window=>window_size-start_column
                              end_column   = zif_popup_window=>window_size-end_column
                              start_line   = zif_popup_window=>window_size-start_line
                              end_line     = zif_popup_window=>window_size-end_line ).
  endmethod.

  method set_screen_status.
    output->set_screen_status( report   = zif_popup_window=>screen_status-program
                               pfstatus = zif_popup_window=>screen_status-status ).
  endmethod.

endclass.