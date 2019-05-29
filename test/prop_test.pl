package db_conn;

use strict;
use warnings;

use DBI;
use util::prop;

my $conn;

my $obj = util::prop->new(name => "env");
my $properties = $obj->load();

my $dbUrl = $properties->getProperty('db.url');

print $dbUrl;