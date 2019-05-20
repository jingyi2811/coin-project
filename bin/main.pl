#!/usr/bin/perl
use strict;
use warnings;

use Plack::Request;
use JSON qw(to_json);
use feature qw(say);

use db::address_pool;
use db::coin_withdraw;

use rpc;

my %ROUTING = (
    '/generate_address'  => \&generate_address,
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
        [ 'Content-Type' => 'text/html' ],
        [ '404 Not Found' ],
    ];
};

sub generate_address {

    my $env = shift;

    my $request = Plack::Request->new($env);

    rpc->init();

    db::address_pool->init();
    my $count = db::address_pool->selectCount();

    for (my $i = 1 ; $i <= 500 - $count ; $i++) {

        my $new_address = rpc->connect('getnewaddress');

        db::address_pool->insert(1, $new_address);
        say 'inserting new address '.$new_address;
    }

    return [
        '200',
        [ 'Content-Type' => 'application/json' ],
        [ to_json '' ],
    ];
}

sub coin_deposit {

    my $env = shift;

    my $request = Plack::Request->new($env);

    my $coin_id = $request->param('coin_id');
    my $user_id = $request->param('user_id');
    my $to_address = $request->param('to_address');

    if (not defined $coin_id) {
        return [
            '404',
            [ 'Content-Type' => 'text/html' ],
            [ '404 Not Found' ],
        ];
    }

    db::coin_deposit->init();

    my $count = db::coin_deposit->selectCountAddress($to_address);

    if ($count > 0) {
        return [
            '404',
            [ 'Content-Type' => 'text/html' ],
            [ 'The address is used before. Please generate another address.' ],
        ];
    }

    rpc->init();

    my $balance = rpc->connect('getbalance', $to_address);

    if ($balance > 0) {

        say 'Deposit detected. The amount is ' . $balance;
        my $count = db::coin_deposit->insert($coin_id, $user_id, $to_address, $balance);

        return [
            '200',
            [ 'Content-Type' => 'application/json' ],
            [ 'A new deposit detected for address =' .$to_address.'. The amount is '.$balance ],
        ];

    } else {

        return [
            '200',
            [ 'Content-Type' => 'application/json' ],
            [ 'No new deposit detected for address =' .$to_address.'.' ],
        ];
    }

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
            [ 'Content-Type' => 'text/html' ],
            [ '404 Not Found' ],
        ];
    }

    #my $user_id = 1;
    #my $from_address = 1;
    #my $to_address = '1M72Sfpbz1BPpXFHz9m3CdqATR44Jvaydd';
    #my $amount = '0.1';

    rpc->init();

    # Perform withdrawal

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