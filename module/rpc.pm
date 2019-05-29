#!/usr/bin/perl

package rpc;

use strict;
use warnings;

use DBI;
use Config::Properties;
use JSON::RPC::Client;

use util::prop;

my $nodeUrl;
my $nodeUser;
my $nodePassword;

sub init {

    my $self = shift;

    my $obj = util::prop->new(name => "env");
    my $properties = $obj->load();

    $nodeUrl = $properties->getProperty('node.url');
    $nodeUser = $properties->getProperty('node.user');
    $nodePassword  =  $properties->getProperty('node.password');

}

sub connect(){

    my $self = shift;
    my ($methodName, @arr) = @_;

    my $client = new JSON::RPC::Client;

    $client->ua->credentials(
        $nodeUrl, 'jsonrpc', $nodeUser => $nodePassword
    );

    my $uri = 'http://'.$nodeUrl;

    my $obj = {
        method  => $methodName,
        params  => [@arr],
    };

    my $res = $client->call( $uri, $obj );

    if ($res){

        if ($res->is_error) {
            return $res->error_message;
        }
        else {
            return $res->result;
        }

    } else {
        print $client->status_line;
        return 0;
    }
}

1;