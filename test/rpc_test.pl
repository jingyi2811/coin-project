#!/usr/bin/perl
use strict;
use warnings;

use rpc;

rpc->init();

my $new_address = rpc->connect('getnewaddress');

print $new_address;

1;