package rpc;

use Moose;
use DBI;
use Config::Properties;
use JSON::RPC::Client;
use Data::Dumper;

use util::prop;

# properties
my $nodeUrl;
my $nodeUser;
my $nodePassword;

sub init {

    my $self = shift;

    my $obj1 = util::prop->new(category => 0, name => "env");
    my $properties = $obj1->load();

    $nodeUrl = $properties->getProperty('node.url');
    $nodeUser = $properties->getProperty('node.user');
    $nodePassword  =  $properties->getProperty('node.password');

}

sub connect(){

    my $self = shift;
    my ($methodName) = @_;

    my $client = new JSON::RPC::Client;

    $client->ua->credentials(
        $nodeUrl, 'jsonrpc', $nodeUser => $nodePassword  # REPLACE WITH YOUR bitcoin.conf rpcuser/rpcpassword
    );

    my $uri = 'http://'.$nodeUrl;

    my $obj = {
        method  => $methodName,
        params  => [],
    };

    my $res = $client->call( $uri, $obj );

    if ($res){
        if ($res->is_error) { print "Error : ", $res->error_message; }
        else { return $res->result; }
    } else {
        print $client->status_line;
    }
}

no Moose;

1;