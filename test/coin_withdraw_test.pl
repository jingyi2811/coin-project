#!/usr/bin/perl

use strict;
use warnings;

use db::coin_withdraw;

db::coin_withdraw->init();

db::coin_withdraw->insert('1','1','test', 'testfromaddress', 'testtoaddress', '1.22');

1;