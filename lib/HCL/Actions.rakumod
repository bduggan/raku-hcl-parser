unit class HCL::Actions;

method TOP($/) {
  $/.make: $<config-file>.made;
}

method config-file($/) {
  $/.make: $<body>.made;
}

method body($/) {
  $/.make: %( $<piece>.map: *.made )
}

method piece($/) {
  $/.make: $<attribute>.made // $<block>.made // $<one-line-block>.made
}

method identifier($/) {
  $/.make: "$/";
}

method attribute($/) {
  $/.make: $<identifier>.made => $<expression>.made
}

method expression($/) {
  $/.make: $<operation>.made // $<expr-term>.made
}

method operation($/) {
  $/.make: $<expr-term>[0].made
  #%( ( $<$expr-term>.map: *.made) => ($<expression>.map: *.made) )
}

method expr-term($/) {
  $/.make:
     $<function-call>.made
      // $<literal>.made
      // $<collection-value>.made
      // $<for-expr>.made
      // $<expression>.made
      // $<template-expr>.made
    #=> $<index>.map(*.made).join // $<get-attr>.map(*.made) // $<splat>.map(*.made)
}

method template-expr($/) {
  $/.make: $<quoted-template>.made;
}

method quoted-template($/) {
  $/.make: ~$<template>
}

method collection-value($/) {
  $/.make: $<tuple>.made // $<object>.made
}

method tuple($/) {
  $/.make: "TODO tuple $/";
}

method object($/) {
  $/.make: %( $<object-elem>.map: *.made )
}

method object-elem($/) {
  $/.make: ( $<identifier>.made // "TODO expr $<expression>" => $<val>.made );
}

method block($/) {
  $/.make:
    %(
      $<identifier>.Str => $<body>.made,
      |( $<rest> ?? _meta => "$<rest>" !! Empty)
     )
}

method one-line-block($/) {
  $/.make: 99
}
