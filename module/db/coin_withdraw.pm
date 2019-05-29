#!/usr/bin/perl

package db::coin_withdraw;

use db_conn;

use strict;
use warnings;

sub init {

    my $self = shift;

    db_conn -> init();
}

sub insert{

    my $self = shift;

    my ($coin_id, $user_id, $tx_id, $from_address, $to_address, $amount) = @_;

    my $sql = "INSERT INTO coin_withdraw (coin_id, user_id, tx_id, from_address, to_address, amount, created_date, updated_date) VALUES ";
    $sql = $sql."(?, ?, ?, ?, ?, ?, current_timestamp, current_timestamp)";

    my $result = db_conn -> execute($sql, @_);

    return $result

}

sub disconnect(){

    db_conn -> disconnect();
}

1;