use strict;
use warnings;

use Test::More 'no_plan';
use Data::Dumper;

BEGIN { use_ok("Recs::Aggregator::Records"); }
BEGIN { use_ok("Recs::Record"); }

{
   my $aggr = Recs::Aggregator::Records->new();

   my $cookie = $aggr->initial();

   foreach my $r ([1, 2], [3, 4], [5, 7])
   {
      $cookie = $aggr->combine($cookie, Recs::Record->new("x" => $r->[0], "y" => $r->[1]));
   }

   my $value = $aggr->squish($cookie);

   is_deeply($value, [{"x" => 1, "y" => 2}, {"x" => 3, "y" => 4}, {"x" => 5, "y" => 7}], "records for (1, 2), (3, 4), (5, 7)");
}
