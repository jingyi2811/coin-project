#!/usr/bin/perl
use strict;
use warnings;

use Plack::Request;
use Plack::Builder;

use JSON qw(to_json);
use feature qw(say);

use db::address_pool;
use db::coin_deposit;
use db::coin_withdraw;

use rpc;

db::coin_deposit->init();

rpc->init();

my $balance = rpc->connect('getreceivedbyaddress', 'QX89gmNBV4pT4H3Dds1ZWQxdVtdJuqnfBd');

my $count = db::coin_deposit->selectCountAddress('QX89gmNBV4pT4H3Dds1ZWQxdVtdJuqnfBd');

if ($count == 0) {
    my $count = db::coin_deposit->insert(1, 1, 'QX89gmNBV4pT4H3Dds1ZWQxdVtdJuqnfBd', $balance);
}
