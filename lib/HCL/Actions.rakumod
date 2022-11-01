unit class HCL::Actions;

method TOP($/) {
  $/.make: $<config-file>.made;
}

method config-file($/) {
  $/.make: $<body>.made;
}

method body($/) {
  $/.make: $<piece>.map: *.made
}

method piece($/) {
  $/.make: $<attribute>.made // $<block>.made // $<one-line-block>.made
}

method attribute($/) {
  $/.make: "$<identifier>" => $<expression>.made
}

method expression($/) {
  $/.make: "$/"
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
