*&---------------------------------------------------------------------*
*& Include Z_SOFWARE_METRICS_TOP
*&---------------------------------------------------------------------*
tables: tadir, seoclass.
constants: begin of c_sel_name,
             complexity type string value 'C_MCCABE',
             authors    type string value 'C_VRSD',
             object     type string value 'S_OBJECT',
             name       type string value 'S_NAME',
             package    type string value 'S_DEVCL',
           end of c_sel_name.
constants: begin of c_kind,
             param   type c value 'P',
             sel_opt type c value 'S',
           end of c_kind.
constants: begin of c_sign,
             inclu type c value 'I',
             exlcy type c value 'E',
           end of c_sign.
constants: begin of c_option,
             equal     type string value 'EQ',
             not_equal type string value 'NE',
           end of c_option.
constants obj_type type string value 'CLAS'.

types: begin of class_struc,
         class type ref to z_class,
       end of class_struc.
types classes_tab_type type standard table of class_struc.

types: begin of classes_for_calc_struct,
         class_name type string,
       end of classes_for_calc_struct.

data parameters type standard table of rsparams.
data class_stamp type z_class_manager=>class_stamp_tab_type.
data memory_id(60) type c.
data classes_for_calculation type standard table of classes_for_calc_struct.