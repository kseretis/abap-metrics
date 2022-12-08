interface zif_popup_window public.

  constants: begin of answers,
               yes type string value 'YES',
               no  type string value 'NO',
             end of answers.

  constants: begin of screen_status,
               program type syrepid value 'Z_SOFTWARE_METRICS',
               status  type sypfkey value 'POPUP_WINDOW',
             end of screen_status.

  constants: begin of labels,
               object  type scrtext_l value 'Package/Class',
               message type scrtext_l value 'Message',
             end of labels.

  constants title type lvc_title value 'Error messages'.

  constants: begin of header,
               title type string value 'There was some issue/issues with the following objects.',
               text  type string value 'If you want to continue without their calculation, press OK.',
             end of header.

  constants: begin of window_size,
               start_column type i value 1,
               end_column   type i value 60,
               start_line   type i value 1,
               end_line     type i value 10,
             end of window_size.

endinterface.