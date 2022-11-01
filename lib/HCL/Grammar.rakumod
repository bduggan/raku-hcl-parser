use Grammar::PrettyErrors;
unit grammar HCL::Grammar does Grammar::PrettyErrors;

token ws {
  <!ww> \h* [ <comment>]?
}

# TODO inline comments
rule comment {
    [ '#' | '//' ] \V* \n
}

rule TOP {
  <config-file>
}

rule config-file {
  <body>
}

rule body {
  \s*
  <piece> * %% \n
}

rule piece {
  <attribute> | <block> | <one-line-block>
}

rule one-line-block {
   '{' <identifier> [ <string> | <identifier> ]* '{' 
   [ <identifier> '=' <expression> ]?
   '}'
   \n
}

rule block {
  <identifier> [ $<rest> = [ <string> | <identifier> ] ]*
  '{' \n*
    <body>
  '}'
  [ \n | $$ ]
}

rule attribute {
  <identifier> '=' <expression>
}

token variable {
  <identifier>+ % '.'
}

rule expression {
  | <operation>
  | <expr-term>
}


rule operation {
  [ <unary-op> ? <expr-term> ] + % <binary-op> [ '?' \n* <expression> ':' \n* <expression> ]?
}
proto token binary-op { * }

# compare operators
token binary-op:sym<==> { <sym> }
token binary-op:sym<!=> { <sym> }
token binary-op:sym<\<> { <sym> }
token binary-op:sym<\>> { <sym> }
token binary-op:sym<\<=> { <sym> }
token binary-op:sym<\>=> { <sym> }

# arithmetic operators
token binary-op:sym<+> { <sym> }
token binary-op:sym<-> { <sym> }
token binary-op:sym<*> { <sym> }
token binary-op:sym</> { <sym> }
token binary-op:sym<%> { <sym> }

# logic operators
token binary-op:sym<&&> { <sym> }
token binary-op:sym<||> { <sym> }
token binary-op:sym<|> { <sym> }
token binary-op:sym<!> { <sym> }

proto token unary-op { * }
token unary-op:sym<-> { <sym> ' ' } # require space to disambiguate from identifiers
token unary-op:sym<!> { <sym> }

rule expr-term {
  [
    | <function-call>
    | <literal>
    | <collection-value>
    | <template-expr>
    | <variable>
    | <for-expr>
    | "(" <expression> ")"
  ]
  [ <index> | <get-attr> | <splat> ]*
}

rule index {
  '[' <expression> ']'
}

rule get-attr {
  '.' <identifier>
}

rule splat {
  | '.' '*' <get-attr>
  | '[' '*' ']' [ <get-attr> | <index> ]*
}

rule function-call {
  <identifier> "(" \n* <arguments> \n* ")"
}

rule arguments {
  <expression>+ % [ "," \n* ]
  "..."?
}

rule for-expr {
  <for-tuple-expr> | <for-object-expr>
}

rule for-tuple-expr {
  "[" <for-intro> \n* <expression> <for-cond>? "]"
}

rule for-object-expr {
  '{' \n* <for-intro> \n* <expression> '=>' <expression> '...'? <for-cond>? \n? '}'
}

rule for-intro {
  "for" <identifier>+ % "," "in" <expression> ":"
}

rule for-cond {
  "if" <expression>
}

rule collection-value {
  <tuple> | <object>
}

rule tuple {
  "[" \n* <expression>* %% [ "," \n* ]  "]"
}

rule object {
  '{' \n*
  [ <object-elem> * %% [ \n ] ] # https://github.com/hashicorp/hcl/pull/563
  '}' 
}

rule object-elem {
  [ <identifier> | <expression> ] [ "=" | ":" ] <expression>
}

# TODO
# http://unicode.org/reports/tr31/
token identifier {
  [<[\w] + [-] + [_]>]+
  # <id_start> <id_continue>*
}

# [\p{L}\p{Nl}\p{Other_ID_Start}-\p{Pattern_Syntax}-\p{Pattern_White_Space}]
token id_start {
  <[a..z]>
}
# [\p{ID_Start}\p{Mn}\p{Mc}\p{Nd}\p{Pc}\p{Other_ID_Continue}-\p{Pattern_Syntax}-\p{Pattern_White_Space}]
token id_continue {
  <[a..z]> + <[-]>
}

token literal {
  | \d+ [ '.' \d+ ]?
  | "true"
  | "false"
  | "null"
}

token string {
  '"' <-["]>* '"'
}

# TODO heredoc-template
#heredocTemplate = (
#    ("<<" | "<<-") Identifier Newline
#    (content as defined in prose above)
#    Identifier Newline
#);
token template-expr {
  <quoted-template>
}

token quoted-template {
  '"' <template> '"'
}

# TODO or template-directive: template-if, template-for
token template {
  [ <template-literal> | <template-interpolation> ]*
}

token template-literal {
	[ <-[$"%]>+ | '$$' | '%%' ]
}

token template-interpolation {
  '${' '~'? <expression> '~'? '}'
}


