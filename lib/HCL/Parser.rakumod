unit module HCL::Parser;
use HCL::Grammar;

sub parse(Str $string) is export {
  HCL::Grammar.new.parse($string);
}
