#!/usr/bin/perl

use strict;
use warnings;

use db::coin_deposit;

db::coin_deposit->init();

my $countAddress = db::coin_deposit->selectCountAddress('test');

print 'Count address = '.$countAddress."\n";

db::coin_deposit->insert(1,1,'test',1);

$countAddress = db::coin_deposit->selectCountAddress('test');

print 'Count address = '.$countAddress."\n";

1;