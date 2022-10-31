#!raku

use HCL::Grammar;
use Test;

my $g := HCL::Grammar.new;

ok $g.parse(q:to/HCL/.trim, :rule<object>), 'object with comment';
{
  # comment
  one = 1
}
HCL

ok $g.parse(q:to/HCL/, :rule<block>), 'block with comment';
abc {
  # comment
  two = 2
  x = 1
  x = 1
}
HCL

done-testing;
