*&---------------------------------------------------------------------*
*& Include Z_SOFTWARE_METRICS_SCREEN
*&---------------------------------------------------------------------*
selection-screen begin of block b1 with frame title text-001.

  selection-screen begin of line.
    selection-screen comment 8(24) for field is_pack.
    parameters is_pack radiobutton group rbg2 user-command ud1.
    selection-screen comment 40(15) for field s_pack.
    select-options: s_pack for tadir-devclass no intervals.
  selection-screen end of line.

  selection-screen begin of line.
    selection-screen comment 11(21) for field is_class.
    parameters is_class radiobutton group rbg2 default 'X'.
    selection-screen comment 40(15) for field s_class.
    select-options: s_class for seoclass-clsname no intervals matchcode object seo_classes_interfaces.
  selection-screen end of line.

selection-screen end of block b1.

selection-screen begin of block b2 with frame title text-002.
  parameters: rb_meth radiobutton group rbg1 default 'X',
              rb_clas radiobutton group rbg1.
  parameters: cb_cbo  as checkbox default abap_false,
              cb_test as checkbox default abap_false.
selection-screen end of block b2.

selection-screen begin of block b3 with frame title text-003.
  parameters: rb_total radiobutton group rbg3 default 'X',
              rb_avg   radiobutton group rbg3.
selection-screen end of block b3.

at selection-screen output.
  loop at screen.
    if screen-name = 'S_PACK-LOW'.
      screen-input = cond #( when is_pack = abap_true then 1 else 0 ).
    elseif screen-name = 'S_CLASS-LOW'.
      screen-input = cond #( when is_class = abap_true then 1 else 0 ).
    endif.
    modify screen.
  endloop.