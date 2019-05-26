package rpc;

use Moose;
use DBI;
use Config::Properties;
use JSON::RPC::Client;
use Data::Dumper;
use feature qw(say);

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
    my ($methodName, $param) = @_;
    my @array = $param;

    my $client = new JSON::RPC::Client;

    $client->ua->credentials(
        $nodeUrl, 'jsonrpc', $nodeUser => $nodePassword  # REPLACE WITH YOUR bitcoin.conf rpcuser/rpcpassword
    );

    my $uri = 'http://'.$nodeUrl;

    my $obj = {
        method  => $methodName,
        params  => [@array],
    };

    my $res = $client->call( $uri, $obj );

    say $res->result;

    if ($res){
        if ($res->is_error) { say "Error : ", $res->error_message; return 0;}
        else { return $res->result; }
    } else {
        say $client->status_line;
        return 0;
    }
}

no Moose;

1;