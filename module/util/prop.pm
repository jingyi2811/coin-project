package util::prop;

use Moose;
use Config::Properties;
use FindBin;

has 'category'  => (is => 'rw', isa => 'Int');
has 'name'  => (is => 'rw', isa => 'Str');

my $path;

sub load {

    my $self = shift;

    if($self->category == 0){
        $path = "$FindBin::Bin/../resource/".$self->name.".properties";
    }

    open my $cfh, '<', $path or die "unable to open property file";

    my $properties = Config::Properties->new();
    $properties->load($cfh);

    return $properties;
}

no Moose;

1;