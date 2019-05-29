#!/usr/bin/perl
use strict;
use warnings;

use util::prop;
use db_conn;

my $conn;

db_conn -> init();

my @param = ('2533', '1');

my $sql = "select id from address_pool where id = ? and coin_id = ?";
my $stmt = db_conn -> execute($sql, @param);

my $count = '';

if ( my @row = $stmt->fetchrow_array ) {
    $count = "@row\n";
}

print $count;

@param = ('1', '1', '1');

$sql = "insert into address_pool (coin_id, address, private_key) values (?,?,?)";
$stmt = db_conn -> execute($sql, @param);

1;