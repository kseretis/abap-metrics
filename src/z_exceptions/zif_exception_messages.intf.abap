interface zif_exception_messages public.

  constants: begin of no_methods,
               msgid type symsgid value 'Z_MESSAGES',
               msgno type symsgno value '001',
               attr1 type scx_attrname value 'VALUE',
               attr2 type scx_attrname value '',
               attr3 type scx_attrname value '',
               attr4 type scx_attrname value '',
             end of no_methods.

  constants: begin of method_not_found,
               msgid type symsgid value 'Z_MESSAGES',
               msgno type symsgno value '002',
               attr1 type scx_attrname value 'VALUE',
               attr2 type scx_attrname value '',
               attr3 type scx_attrname value '',
               attr4 type scx_attrname value '',
             end of method_not_found.

  constants: begin of empty_version_list,
               msgid type symsgid value 'Z_MESSAGES',
               msgno type symsgno value '003',
               attr1 type scx_attrname value '',
               attr2 type scx_attrname value '',
               attr3 type scx_attrname value '',
               attr4 type scx_attrname value '',
             end of empty_version_list.

  constants: begin of salv_build_failed,
               msgid type symsgid value 'Z_MESSAGES',
               msgno type symsgno value '004',
               attr1 type scx_attrname value '',
               attr2 type scx_attrname value '',
               attr3 type scx_attrname value '',
               attr4 type scx_attrname value '',
             end of salv_build_failed.

  constants: begin of obj_does_not_exist,
               msgid type symsgid value 'Z_MESSAGES',
               msgno type symsgno value '006',
               attr1 type scx_attrname value '',
               attr2 type scx_attrname value '',
               attr3 type scx_attrname value '',
               attr4 type scx_attrname value '',
             end of obj_does_not_exist.

  constants: begin of empty_package,
               msgid type symsgid value 'Z_MESSAGES',
               msgno type symsgno value '007',
               attr1 type scx_attrname value '',
               attr2 type scx_attrname value '',
               attr3 type scx_attrname value '',
               attr4 type scx_attrname value '',
             end of empty_package.

  constants: begin of no_package,
               msgid type symsgid value 'Z_MESSAGES',
               msgno type symsgno value '008',
               attr1 type scx_attrname value '',
               attr2 type scx_attrname value '',
               attr3 type scx_attrname value '',
               attr4 type scx_attrname value '',
             end of no_package.

  constants: begin of no_matching_keyword,
               msgid type symsgid value 'Z_MESSAGES',
               msgno type symsgno value '009',
               attr1 type scx_attrname value '',
               attr2 type scx_attrname value '',
               attr3 type scx_attrname value '',
               attr4 type scx_attrname value '',
             end of no_matching_keyword.

  constants: begin of no_class_found,
               msgid type symsgid value 'Z_MESSAGES',
               msgno type symsgno value '010',
               attr1 type scx_attrname value 'VALUE',
               attr2 type scx_attrname value '',
               attr3 type scx_attrname value '',
               attr4 type scx_attrname value '',
             end of no_class_found.

  constants: begin of no_class,
               msgid type symsgid value 'Z_MESSAGES',
               msgno type symsgno value '011',
               attr1 type scx_attrname value '',
               attr2 type scx_attrname value '',
               attr3 type scx_attrname value '',
               attr4 type scx_attrname value '',
             end of no_class.

  constants: begin of zero_divider,
               msgid type symsgid value 'Z_MESSAGES',
               msgno type symsgno value '012',
               attr1 type scx_attrname value '',
               attr2 type scx_attrname value '',
               attr3 type scx_attrname value '',
               attr4 type scx_attrname value '',
             end of zero_divider.

endinterface.