*&---------------------------------------------------------------------*
*& Include Z_SOFTWARE_METRICS_SCREEN
*&---------------------------------------------------------------------*
selection-screen begin of block b1 with frame title text-001.
  select-options: s_pack for tadir-devclass no intervals.
  select-options: s_class for seoclass-clsname no intervals matchcode object seo_classes_interfaces.
selection-screen end of block b1.

selection-screen begin of block b2 with frame title text-002.
  parameters: rb_meth radiobutton group rbg1 default 'X',
              rb_clas radiobutton group rbg1.
  parameters: cb_cbo as checkbox default abap_false.
selection-screen end of block b2.