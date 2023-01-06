interface zif_popup_window public.

  constants: begin of answers,
               yes type string value 'YES',
               no  type string value 'NO',
             end of answers.

  constants: begin of screen_status,
               program type syrepid value 'Z_ABAP_METRICS',
               status  type sypfkey value 'POPUP_WINDOW',
             end of screen_status.

  constants: begin of labels,
               object  type scrtext_l value 'Package/Class' ##NO_TEXT,
               message type scrtext_l value 'Message' ##NO_TEXT,
             end of labels.

  constants title type lvc_title value 'Error messages' ##NO_TEXT.

  constants header type string value 'The objects bellow couldn''t be found!' ##NO_TEXT.
  constants footer type string value 'Do you want to continue without their analysis?' ##NO_TEXT.

  constants: begin of window_size,
               start_column type i value 1,
               end_column   type i value 60,
               start_line   type i value 1,
               end_line     type i value 10,
             end of window_size.

endinterface.