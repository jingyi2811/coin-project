#!/usr/bin/perl

package db::coin_deposit;

use Moose;

use util::prop;
use db_conn;

use feature qw(say);

my $conn;

sub init {

    my $self = shift;

    $conn = db_conn -> new();
    $conn -> init();
}

sub selectCountAddress{

    my $self = shift;
    my ($to_address) = @_;

    my $sql = "select count(*) from coin_deposit where to_address = '".$to_address."'";

    my $stmt = $conn -> select($sql);

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
    $sql = $sql."('${coin_id}', '${user_id}', '${to_address}', '${amount}', current_timestamp, current_timestamp)";

    my $stmt = $conn -> execute($sql);

    return $stmt
}

sub disconnect(){

    my $self = shift;
    $conn -> disconnect();
}

no Moose;

1;