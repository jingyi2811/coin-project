#!/usr/bin/perl

package db::address_pool;

use strict;
use warnings;

use util::prop;
use db_conn;

sub init {

    my $self = shift;

    db_conn -> init();
}

sub selectCount{

    my $self = shift;

    my $sql = "select count(*) from address_pool";
    my $stmt = db_conn -> execute($sql, ());

    my $count = 0;

    if ( my @row = $stmt->fetchrow_array ) {
        $count = "@row\n";
    }

    return $count;
}

sub insert{

    my $self = shift;
    my ($coin_id, $address) = @_;

    my $sql = "insert into address_pool(coin_id, address, private_key, created_date, updated_date) values (?, ?, null, current_timestamp, current_timestamp)";
    my $result = db_conn -> execute($sql, @_);

    return $result;
}

sub selectOne{

    my $self = shift;

    my $sql = "select address FROM address_pool limit 1";
    my $stmt = db_conn -> execute($sql, ());

    my $address = "";

    while ( my @row = $stmt->fetchrow_array ) {
        $address = "@row";
    }

    return $address;
}

sub deleteOne{

    my $self = shift;
    my ($address) = @_;

    my $sql = "delete FROM address_pool where address = ?";
    my $result = db_conn -> execute($sql, @_);

    return $result;
}

sub disconnect(){

    my $self = shift;

    db_conn -> disconnect();
}

1;