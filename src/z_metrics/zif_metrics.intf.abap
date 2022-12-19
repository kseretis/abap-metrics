interface zif_metrics public.

  constants: begin of obj_type,
               meth(4) type c value 'METH',
               clas(4) type c value 'CLAS',
             end of obj_type.

  constants: begin of method_call,
               instance type string value '->',
               static   type string value '=>',
             end of method_call.

  constants: begin of token_type,
               comment type string value 'C',
               pragma  type string value 'P',
             end of token_type.

  constants: begin of tokens,
               or  type string value 'OR',
               and type string value 'AND',
             end of tokens.

  constants: begin of scan_type,
               none          type string value 'NONE',
               simple        type string value 'SIMPLE',
               with_comments type string value 'WITH_COMMENTS',
               with_pragmas  type string value 'WITH_PRAGMAS',
               with_keywords type string value 'WITH_KEYWORDS',
             end of scan_type.

  constants cohesive_value type i value 1.

  constants: begin of local_declaration,
               data          type string value 'DATA',
               field_symbols type string value 'FIELD-SYMBOLS',
               field_symbol  type string value 'FIELD-SYMBOL',
             end of local_declaration.

  constants: begin of symbols,
               parenthesis_open  type string value '(',
               parenthesis_close type string value ')',
               at                type string value '@',
               dash              type string value '-',
               blank             type string value '',
             end of symbols.

endinterface.