*"* use this source file for your ABAP unit test classes
class z_code_scanner_factory_test definition final for testing duration short risk level harmless.

  private section.
    data source_code type rswsourcet.
    methods setup.
    methods factory_none for testing.
    methods factory_simple for testing.
    methods factory_with_comments for testing.
    methods factory_with_pragmas for testing.
    methods factory_with_keywords for testing.
    methods factory_with_keywords_depth for testing.

endclass.

class z_code_scanner_factory_test implementation.

  method setup.
    source_code = value #( ( `     method test_scan_factory.    ` )
                          ( `         "first comment   ` )
                          ( `         loop at mara_tab assigning field-symbol(<fs>).   ` )
                          ( `           try.   ` )
                          ( `               <fs>-matnr = 'test'.   ` )
                          ( `             catch zcx_flow_issue ##NO_HANDLER.   ` )
                          ( `           endtry.    ` )
                          ( `         endloop.     ` )
                          ( `         if one = 2.  ` )
                          ( `           check one <> 3.    ` )
                          ( `         endif.   ` )
                          ( `     endmethod.     ` ) ).
  endmethod.

  method factory_none.
    cl_abap_unit_assert=>assert_initial( z_code_scanner_factory=>factory( scan_type   = zif_metrics=>scan_type-none
                                                                          source_code = source_code ) ).
  endmethod.

  method factory_simple.
    data(scan_results) = z_code_scanner_factory=>factory( scan_type   = zif_metrics=>scan_type-simple
                                                          source_code = source_code ).
    try.
        data(value) = scan_results-tokens[ str = '"first comment' ].
      catch cx_sy_itab_line_not_found into data(ex).
        cl_abap_unit_assert=>assert_not_initial( ex ).
    endtry.
  endmethod.

  method factory_with_comments.
    data(scan_results) = z_code_scanner_factory=>factory( scan_type   = zif_metrics=>scan_type-with_comments
                                                          source_code = source_code ).
    cl_abap_unit_assert=>assert_not_initial( scan_results-tokens[ str = '"first comment' ] ).
  endmethod.

  method factory_with_pragmas.
    data(scan_results) = z_code_scanner_factory=>factory( scan_type   = zif_metrics=>scan_type-with_pragmas
                                                          source_code = source_code ).
    cl_abap_unit_assert=>assert_not_initial( scan_results-tokens[ str = '##NO_HANDLER' ] ).
  endmethod.

  method factory_with_keywords.
    data(scan_results) = z_code_scanner_factory=>factory( scan_type   = zif_metrics=>scan_type-with_keywords
                                                          source_code = source_code ).
    cl_abap_unit_assert=>assert_not_initial( scan_results-tokens[ str = 'CHECK' ] ).
  endmethod.

  method factory_with_keywords_depth.
    data(scan_results) = z_code_scanner_factory=>factory( scan_type   = zif_metrics=>scan_type-with_keywords_depth
                                                          source_code = source_code ).
    try.
        data(value) = scan_results-tokens[ str = 'CHECK' ].
      catch cx_sy_itab_line_not_found into data(ex).
        cl_abap_unit_assert=>assert_not_initial( ex ).
    endtry.
  endmethod.

endclass.