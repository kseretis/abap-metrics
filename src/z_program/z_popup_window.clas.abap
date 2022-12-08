class z_popup_window definition public final create public.

    public section.
      types: begin of message_struct,
               object(20)  type c,
               message(50) type c,
             end of message_struct .

      constants: begin of answers,
                   yes type string value 'YES',
                   no  type string value 'NO',
                 end of answers .
      constants: begin of screen_status,
                   program type syrepid value 'Z_SOFTWARE_METRICS',
                   status  type sypfkey value 'POPUP_WINDOW',
                 end of screen_status .
      constants: begin of labels,
                   object  type scrtext_l value 'Object',
                   message type scrtext_l value 'Message',
                 end of labels .

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
          output->get_columns( )->get_column( 'OBJECT' )->set_long_text( labels-object ).
          output->get_columns( )->get_column( 'MESSAGE' )->set_long_text( labels-message ).
        catch cx_salv_msg.
        catch cx_salv_not_found.
      endtry.

      data(header) = new cl_salv_form_layout_grid( ).
      data(header_label) = header->create_label( row = 1 column = 1 ).
      header_label->set_text( 'Test header' ).

      output->get_display_settings( )->set_list_header( 'The title' ).

      output->set_top_of_list( header ).

      output->get_columns( )->set_optimize( abap_true ).
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
        when answers-yes.
          output->close_screen( ).
          answer = abap_true.
        when answers-no.
          output->close_screen( ).
          answer = abap_false.
      endcase.
    endmethod.

    method get_answer.
      return = answer.
    endmethod.

    method set_screen_popup.
      output->set_screen_popup( start_column = 1
                                end_column   = 60
                                start_line   = 1
                                end_line     = 10 ).
    endmethod.

    method set_screen_status.
      output->set_screen_status( report   = screen_status-program
                                 pfstatus = screen_status-status ).
    endmethod.

  endclass.
