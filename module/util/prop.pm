package util::prop;

use Moose;
use Config::Properties;
use FindBin;

has 'name'  => (is => 'rw', isa => 'Str');

my $path;

sub load {

    my $self = shift;

    $path = "$FindBin::Bin/../resource/".$self->name.".properties";

    print $path;

    open my $cfh, '<', $path or die "unable to open property file";

    my $properties = Config::Properties->new();
    $properties->load($cfh);

    return $properties;
}

no Moose;

1;