class z_loc_calculator definition public create public inheriting from z_code_scanner.

  public section.
    methods constructor
      importing source_code type rswsourcet.
    methods calculate redefinition.

  protected section.

  private section.

endclass.

class z_loc_calculator implementation.

  method constructor.
    super->constructor( scan_type   = zif_metrics=>scan_type-none
                        source_code = source_code ).
  endmethod.

  method calculate.
    data(lines) = get_source_code( ).
    data lines_of_code like lines.

    loop at lines into data(line) where table_line is not initial.
      data(first_char) = condense( line ).
      first_char = first_char+0(1).
      if first_char <> '"' and first_char <> '*' .
        insert line into table lines_of_code.
      endif.
    endloop.

    return = lines( lines_of_code ).
  endmethod.

endclass.