#!/usr/bin/perl
use strict;
use warnings;

use rpc;

use db::address_pool;

rpc->init();

my $new_address = rpc->connect('getnewaddress');

print 'New address = '.$new_address."\n";

db::address_pool->init();

my $status = db::address_pool->insert(1,$new_address);

print 'Status = '.$status."\n";

my $selectCount = db::address_pool->selectCount();

print 'Select count = '.$selectCount."\n";

my $selectOne = db::address_pool->selectOne();

print 'Select one = '.$selectOne."\n";

db::address_pool->deleteOne($new_address);

db::address_pool->disconnect();

1;