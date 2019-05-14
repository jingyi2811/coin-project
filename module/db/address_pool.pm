#!/usr/bin/perl

package db::address_pool;

use Moose;

use util::prop;
use db_conn;

my $conn;

sub init {

    my $self = shift;

    $conn = db_conn -> new();
    $conn -> init();
}

sub selectCount{

    my $self = shift;

    my $sql = "select count(*) from address_pool";
    my $stmt = $conn -> select($sql);

    my $count;

    if ( my @row = $stmt->fetchrow_array ) {
        $count = "@row\n";
    }

    return $count;
}

sub selectAll{

    my $self = shift;

    my $sql = "select id, coin_id, address, private_key, created_date, updated_date FROM address_pool";
    my $stmt = $conn -> select($sql);

    while ( my @row = $stmt->fetchrow_array ) {
        print "@row\n";
    }

    return $stmt;
}

sub insert{

    my $self = shift;
    my ($coin_id, $address) = @_;

    my $sql = "insert into address_pool(coin_id, address, private_key, created_date, updated_date) values ('${coin_id}', '${address}', null, current_timestamp, current_timestamp)";
    my $stmt = $conn -> execute($sql);

    return $stmt
}

sub disconnect(){

    my $self = shift;

    $conn -> disconnect();
}

no Moose;

1;