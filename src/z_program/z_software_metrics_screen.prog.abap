*&---------------------------------------------------------------------*
*& Include Z_SOFTWARE_METRICS_SCREEN
*&---------------------------------------------------------------------*
selection-screen begin of block b1 with frame title text-001.
  select-options: s_pack for tadir-devclass no intervals.
  select-options: s_class for tadir-obj_name no intervals.
  parameters: cb_cbo as checkbox default abap_false.
selection-screen end of block b1.