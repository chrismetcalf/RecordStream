package Recs::Operation::fromdb;

use strict;
use warnings;

use base qw(Recs::Operation);

use DBI;

use Recs::DBHandle;
use Recs::OutputStream;
use Recs::Record;

sub init {
   my $this = shift;
   my $args = shift;

   my ($table_name, $sql);
   my $spec = {
      'table=s' => \$table_name,
      'sql=s'   => \$sql,
   };

   Getopt::Long::Configure("pass_through");
   $this->parse_options($args, $spec);

   $this->{'TABLE_NAME'} = $table_name;

   my $dbh = Recs::DBHandle::get_dbh($this->_get_extra_args());
   $this->{'DBH'} = $dbh;

   die("Must define --table or --sql") unless ( $table_name || $sql );

   unless ( $sql ) {
     $sql = "SELECT * FROM $table_name";
   }

   $this->{'SQL'} = $sql;
}

sub run_operation {
  my $this = shift;

  my $sth = $this->{'DBH'}->prepare($this->{'SQL'});
  $sth->execute();

  while ( my $row = $sth->fetchrow_hashref() ) {
    my $record = Recs::Record->new(%$row);
    $this->push_record($record);
  }
}

sub usage {
   my $usage =  <<USAGE;
   Recs from DB will execute a select statement on a database of your choice,
   and create a record stream from the results.  The keys of the record will be
   the column names and the values the row values.

   --table - Name of the table to dump, this is a shortcut for
             --sql 'SELECT * from tableName'
   --sql   - SQL select statement to run

USAGE

   return $usage . Recs::DBHandle::usage() .  <<EXAMPLES;
Examples:
   # Dump a table
   recs-fromdb --type sqlite --dbfile testDb --table recs

   # Run a select statement
   recs-fromdb --dbfile testDb --sql 'SELECT * FROM recs WHERE id > 9'
EXAMPLES
}

1;
