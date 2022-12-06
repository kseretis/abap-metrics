*&---------------------------------------------------------------------*
*& Include Z_SOFTWARE_METRICS_SCREEN
*&---------------------------------------------------------------------*
selection-screen begin of block b1 with frame title text-001.
  select-options: s_pack for tadir-devclass no intervals.
  select-options: s_class for seoclass-clsname no intervals matchcode object seo_classes_interfaces.
  parameters: cb_cbo as checkbox default abap_false.
selection-screen end of block b1.