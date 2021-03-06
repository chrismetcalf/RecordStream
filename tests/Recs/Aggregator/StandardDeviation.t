use strict;
use warnings;

use Test::More 'no_plan';
use Data::Dumper;

BEGIN { use_ok("Recs::Aggregator::StandardDeviation"); }
BEGIN { use_ok("Recs::Record"); }

my $aggr = Recs::Aggregator::StandardDeviation->new("x");

my $cookie = $aggr->initial();

foreach my $n (1, 3, 7)
{
   $cookie = $aggr->combine($cookie, Recs::Record->new("x" => $n));
}

my $value = $aggr->squish($cookie);

is($value, sqrt(56 / 9), "standard deviation for 1, 3, 7");
