package db_conn;

use Moose;
use DBI;
use Config::Properties;

use util::prop;

my $conn;

sub init {

    my $self = shift;

    my $obj1 = util::prop->new(category => 0, name => "env");
    my $properties = $obj1->load();

    my $dbDriver = $properties->getProperty('db.driver');
    my $dbName = $properties->getProperty('db.name');
    my $dbUrl =  $properties->getProperty('db.url');
    my $dbUser = $properties->getProperty('db.user');
    my $dbPassword = $properties->getProperty('db.password');

    $conn = DBI->connect($dbUrl, $dbUser, $dbPassword);

    return $conn;
}

sub select{

    my $self = shift;
    my ($sql) = @_;

    my $stmt = $conn->prepare( $sql );

    $stmt->execute() or die $DBI::errstr;

    return $stmt;
}

# This method is used by either insert, update or delete.
sub execute{

    my $self = shift;
    my ($sql) = @_;

    my $rv = $conn->do($sql) or die $DBI::errstr;
}

sub disconnect(){

    my $self = shift;

    $conn->disconnect();
}

no Moose;

1;