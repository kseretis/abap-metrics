"Name: \PR:/SDF/CD_CUSTOM_CODE_METRIC\TY:CL_CALC_CODE_METRICS\ME:CALC_CODE_METRIC_FOR_OBJECT\SE:END\EI
ENHANCEMENT 0 ZEI_EXPORT_SOURCE_CODE.

  data piece type cl_object_parser=>type_obj_struct.
  data pieces type standard table of cl_object_parser=>type_obj_struct.
  data(count) = 0.

  o_object_parser->get_pieces_count( importing e_pieces_count = count ).

  while count > 0.
    o_object_parser->get_piece(
      exporting
        i_num        = count
      importing
        e_obj_struct = piece ).

    insert piece into table pieces.
    count -= 1.
  endwhile.

  "exports class' source code to memory
  z_class_manager=>export_to_memory( pieces ).

ENDENHANCEMENT.
