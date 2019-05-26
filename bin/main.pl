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


my %ROUTING = (
    '/generate_address'  => \&generate_address,
    '/get_an_address'    => \&get_an_address,
    '/coin_deposit'     => \&coin_deposit,
    '/coin_withdraw'     => \&coin_withdraw,
);

my $app = sub {
    my $env = shift;

    my $request = Plack::Request->new($env);
    my $route = $ROUTING{$request->path_info};
    if ($route) {
        return $route->($env);
    }
    return [
        '404',
        [ 'Content-Type' => 'application/json' ],
        [ '404 Not Found' ],
    ];
};

builder {
    enable 'CrossOrigin', origins => '*';
    $app;
};

sub generate_address {

    my $env = shift;

    my $request = Plack::Request->new($env);

    rpc->init();

    db::address_pool->init();
    my $count = db::address_pool->selectCount();

    if($count == 500){

        return [
            '200',
            [ 'Content-Type' => 'application/json' ],
            [ 'No address is generated.' ],
        ];
    }

    for (my $i = 1 ; $i <= 500 - $count ; $i++) {

        my $new_address = rpc->connect('getnewaddress');

        db::address_pool->insert(1, $new_address);
        say 'inserting new address '.$new_address;

    }

    return [
        '200',
        [ 'Content-Type' => 'application/json' ],
        [ (500 - $count).' address(s) are inserted to the database' ],
    ];
}

sub get_an_address {

    my $env = shift;

    my $request = Plack::Request->new($env);

    db::address_pool->init();
    my $address = db::address_pool->selectOne();

    db::address_pool->deleteOne($address);

    return [
        '200',
        [ 'Content-Type' => 'application/json' ],
        [ $address ],
    ];
}

sub coin_deposit {

    my $env = shift;

    my $request = Plack::Request->new($env);

    my $to_address = $request->param('to_address');

    db::coin_deposit->init();

    rpc->init();

    my $balance = rpc->connect('getreceivedbyaddress', $to_address);

    my $count = db::coin_deposit->selectCountAddress($to_address);

    if ($count == 0) {
        my $count = db::coin_deposit->insert(1, 1, $to_address, $balance);
    }


    return [
        '200',
        [ 'Content-Type' => 'application/json' ],
        [ $balance ],
    ];
}

sub coin_withdraw {

    my $env = shift;

    my $request = Plack::Request->new($env);

    my $coin_id = $request->param('coin_id');
    my $user_id = $request->param('user_id');
    my $from_address = $request->param('from_address');
    my $to_address = $request->param('to_address');
    my $amount = $request->param('amount');

    if (not defined $coin_id) {
        return [
            '404',
            [ 'Content-Type' => 'application/json' ],
            [ '404 Not Found' ],
        ];
    }

    #my $user_id = 1;
    #my $from_address = 1;
    #my $to_address = '1M72Sfpbz1BPpXFHz9m3CdqATR44Jvaydd';
    #my $amount = '0.1';

    rpc->init();

    my @param = { $to_address, $amount };
    my $txid = rpc->connect('sendtoaddress', @param);

    say 'Withdrawal succesfully. The transaction id = ' . $txid;

    db::coin_withdraw->init();
    my $count = db::coin_withdraw->insert($coin_id, $user_id, $txid, $from_address, $to_address, $amount);

    return [
        '200',
        [ 'Content-Type' => 'application/json' ],
        [ to_json '' ],
    ];
}