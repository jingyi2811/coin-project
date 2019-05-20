#!/usr/bin/perl

package db::coin_withdraw;

use Moose;

use util::prop;
use db_conn;

my $conn;

sub init {

    my $self = shift;

    $conn = db_conn -> new();
    $conn -> init();
}

sub insert{

    my $self = shift;
    my ($coin_id, $user_id, $tx_id, $from_address, $to_address, $amount) = @_;

    my $sql = "INSERT INTO coin_withdraw (coin_id, user_id, tx_id, from_address, to_address, amount, created_date, updated_date) VALUES ";
    $sql = $sql."('${coin_id}', '${user_id}', '${tx_id}', '${from_address}', '${to_address}', '${amount}', current_timestamp, current_timestamp)";

    my $stmt = $conn -> execute($sql);

    return $stmt

}

sub disconnect(){

    my $self = shift;
    $conn -> disconnect();
}

no Moose;

1;