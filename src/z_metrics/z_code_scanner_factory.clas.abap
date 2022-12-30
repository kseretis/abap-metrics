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

    class-methods initialize_keywords
      importing scan_type type string.
    class-methods simple_scan.
    class-methods scan_with_comments.
    class-methods scan_with_pragmas.
    class-methods scan_with_keywords
      importing scan_type type string.

endclass.

class z_code_scanner_factory implementation.

  method factory.
    z_code_scanner_factory=>source_code = source_code.
    case scan_type.
      when zif_metrics=>scan_type-simple.
        simple_scan( ).
      when zif_metrics=>scan_type-with_comments.
        scan_with_comments( ).
      when zif_metrics=>scan_type-with_pragmas.
        scan_with_pragmas( ).
      when zif_metrics=>scan_type-with_keywords or zif_metrics=>scan_type-with_keywords_depth.
        scan_with_keywords( scan_type ).
    endcase.
    return = scan_results.
  endmethod.

  method initialize_keywords.
    keywords = cond #( when scan_type = zif_metrics=>scan_type-with_keywords
                        then value #( ( name = 'CHECK' )
                                        ( name = 'IF' )
                                        ( name = 'ELSEIF' )
                                        ( name = 'DO' )
                                        ( name = 'WHILE' )
                                        ( name = 'WHEN' )
                                        ( name = 'LOOP' )
                                        ( name = 'ENDSELECT' )
                                        ( name = 'ENDPROVIDE' )
                                        ( name = 'CATCH' ) )
                         else value #( ( name = 'IF' )
                                        ( name = 'ENDIF' )
                                        ( name = 'DO' )
                                        ( name = 'ENDDO' )
                                        ( name = 'WHILE' )
                                        ( name = 'ENDWHILE' )
                                        ( name = 'CASE' )
                                        ( name = 'ENDCASE' )
                                        ( name = 'LOOP' )
                                        ( name = 'ENDLOOP' ) ) ).
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
    data structures_tab type standard table of sstruc.
    initialize_keywords( scan_type ).
    scan abap-source source_code
        keywords   from keywords
        tokens     into scan_results-tokens
        statements into scan_results-statements
        structures into structures_tab.
  endmethod.

endclass.