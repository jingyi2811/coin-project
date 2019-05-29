#!/usr/bin/perl

package db::coin_deposit;

use strict;
use warnings;

use util::prop;
use db_conn;

sub init {

    my $self = shift;

    db_conn -> init();
}

sub selectCountAddress{

    my $self = shift;
    my ($to_address) = @_;

    my $sql = "select count(*) from coin_deposit where to_address = ? ";
    my $stmt = db_conn -> execute($sql, ($to_address));

    my $count;

    while (my @row = $stmt->fetchrow_array) {
        $count = "@row";
    }

    return $count
}

sub insert{

    my $self = shift;
    my ($coin_id, $user_id, $to_address, $amount) = @_;

    my $sql = "INSERT INTO coin_deposit (coin_id, user_id, to_address, amount, created_date, updated_date) VALUES ";
    $sql = $sql."(?, ?, ?, ?, current_timestamp, current_timestamp)";

    my $stmt = db_conn -> execute($sql, @_);

    return $stmt
}

sub disconnect(){

    db_conn -> disconnect();
}

1;