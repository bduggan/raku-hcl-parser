unit module HCL::Parser;
use HCL::Grammar;
use HCL::Actions;

sub parse-hcl(Str $string, Bool :$parse = False) is export {
  my $actions = HCL::Actions.new;
  my $match = HCL::Grammar.new.parse($string, :$actions);
  fail $match unless $match;
  return $match if $parse;
  $match.made
}
