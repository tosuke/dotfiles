(record
  "(|" @delimiter
  (";" @delimiter)?
  "|)" @delimiter @sentinel) @container

(inline_text
  "{" @delimiter
  "}" @delimiter @sentinel) @container

(block_text
  ["'<" "<"] @delimiter
  ">" @delimiter @sentinel) @container

(cmd_expr_arg
  "(" @delimiter
  ")" @delimiter @sentinel) @container
(cmd_expr_option
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(math_text
  "${" @delimiter
  "}" @delimiter @sentinel) @container
(math_list
  "${" @delimiter
  "|" @delimiter
  "}" @delimiter @sentinel) @container

(math_token
  "{" @delimiter
  sup: (math)
  "}" @delimiter @sentinel) @container
(math_token
  "{" @delimiter
  sub: (math)
  "}" @delimiter @sentinel) @container

(math_cmd_expr_arg
  "{" @delimiter
  "}" @delimiter @sentinel) @container
(math_cmd_expr_arg
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(parened_expr
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(pat_tuple
  "(" @delimiter
  ("," @delimiter)?
  ")" @delimiter @sentinel) @container
(tuple
  "(" @delimiter
  ("," @delimiter)?
  ")" @delimiter @sentinel) @container

(pat_list
  "[" @delimiter
  (";" @delimiter)?
  "]" @delimiter @sentinel) @container
(list
  "[" @delimiter
  (";" @delimiter)?
  "]" @delimiter @sentinel) @container

(type_application
  "(" @delimiter
  ")" @delimiter @sentinel) @container

(type_list
  "[" @delimiter
  "]" @delimiter @sentinel) @container
