class z_code_scanner_factory definition public final create private.

  public section.
    types: begin of keyword_struct,
             name(40) type c,
           end of keyword_struct.
    types tab_type_keywords type standard table of keyword_struct.

    class-methods factory
      importing scan_type     type string
                source_code   type rswsourcet
      returning value(return) type z_code_scanner=>scan_results.

  protected section.

  private section.
    class-data source_code type rswsourcet.
    class-data keywords type tab_type_keywords.
    class-data scan_results type z_code_scanner=>scan_results.

    class-methods initialize_keywords.
    class-methods simple_scan.
    class-methods scan_with_comments.
    class-methods scan_with_pragmas.
    class-methods scan_with_keywords.

endclass.

class z_code_scanner_factory implementation.

  method factory.
    z_code_scanner_factory=>source_code = source_code.
    case scan_type.
      when z_code_scanner=>scan_type-simple.
        simple_scan( ).
      when z_code_scanner=>scan_type-with_comments.
        scan_with_comments( ).
      when z_code_scanner=>scan_type-with_pragmas.
        scan_with_pragmas( ).
      when z_code_scanner=>scan_type-with_keywords.
        scan_with_keywords( ).
    endcase.
    return = scan_results.
  endmethod.

  method initialize_keywords.
    keywords = value #( ( name = 'CHECK' )
                        ( name = 'IF' )
                        ( name = 'ELSEIF' )
                        ( name = 'DO' )
                        ( name = 'WHILE' )
                        ( name = 'WHEN' )
                        ( name = 'LOOP' )
                        ( name = 'ENDSELECT' )
                        ( name = 'ENDPROVIDE' )
                        ( name = 'CATCH' ) ).
  endmethod.

  method simple_scan.
    scan abap-source source_code
       tokens into scan_results-tokens
       statements into scan_results-statements.
  endmethod.

  method scan_with_comments.
    scan abap-source source_code
        tokens into scan_results-tokens
        statements into scan_results-statements
        with comments.
  endmethod.

  method scan_with_pragmas.
    scan abap-source source_code
        tokens into scan_results-tokens
        statements into scan_results-statements
        with comments
        with pragmas 'G'.
  endmethod.

  method scan_with_keywords.
    initialize_keywords( ).
    scan abap-source source_code
        keywords   from keywords
        tokens     into scan_results-tokens
        statements into scan_results-statements.
*        structures into d_strcts_tab.
  endmethod.

endclass.