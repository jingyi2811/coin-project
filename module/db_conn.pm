#!/usr/bin/perl

package db_conn;

use strict;
use warnings;

use DBI;
use Config::Properties;

use util::prop;

my $conn;

sub init {

    my $self = shift;

    my $obj = util::prop->new(name => "env");
    my $properties = $obj->load();

    my $dbUrl =  $properties->getProperty('db.url');
    my $dbUser = $properties->getProperty('db.user');
    my $dbPassword = $properties->getProperty('db.password');

    $conn = DBI->connect($dbUrl, $dbUser, $dbPassword);

    return $conn;
}

sub execute{

    my $self = shift;
    my ($sql, @param) = @_;

    my $array_length = scalar @param;

    my $stmt = $conn->prepare( $sql );

    my $count;

    for ($count = 0 ; $count < $array_length; $count++) {
        $stmt->bind_param( $count + 1, $param[$count]);
    }

    $stmt->execute() or die $DBI::errstr;

    return $stmt;
}

sub disconnect(){

    my $self = shift;

    $conn->disconnect();
}

1;