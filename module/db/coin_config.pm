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

sub select{

    my $self = shift;

    my $sql = "SELECT id, coin_id, coin_type_id, coin_name, url, rpc_name, rpc_password, created_date, updated_date FROM coin_config";
    my $stmt = $conn -> select($sql);

    while ( my @row = $stmt->fetchrow_array ) {
        print "@row\n";
    }

    return $stmt;
}

sub insert{

    my $self = shift;

    my $sql = "insert into address_pool(coin_id, address, private_key) values ('1', '1', '1')";
    my $stmt = $conn -> execute($sql);

    return $stmt
}

sub disconnect(){

    my $self = shift;

    $conn -> disconnect();
}

no Moose;

1;