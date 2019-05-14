#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';
use feature qw(say);

use db::address_pool;
use rpc;

rpc->init();

db::address_pool->init();
my $count = db::address_pool->selectCount();

for (my $i = 1 ; $i <= 500 - $count ; $i++) {

    my $new_address = rpc->connect('getnewaddress');

    db::address_pool->insert(1, $new_address);
    say 'inserting new address '.$new_address;
}

1;