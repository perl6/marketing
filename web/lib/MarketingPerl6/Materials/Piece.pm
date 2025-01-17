package MarketingPerl6::Materials::Piece;

use Mojo::Base -base;
use Mojo::Collection qw/c/;
use File::Spec::Functions qw/catfile/;
use File::Glob qw/bsd_glob/;
use Image::Size;
use URL::Encode qw/url_encode/;

my @valid_types = qw/
    pdf_digital
    pdf_print_bleed     pdf_print
    pdf_print_bleed_US  pdf_print_US
    img  img_square  ai  svg  ico
/;
my %valid_types = map +($_ => 1), 'any', @valid_types;
has [qw/id title  root  base/, @valid_types];

sub thumbs {
    my ($self) = @_;
    my $root = $self->root;
    c(bsd_glob catfile $root, $self->base, 'thumbs', '*.jpg')->map(
        sub {
            $_ =~ s{\Q$root\E/}{}r
        }
    );
}

sub has_type {
    my ($self, $type) = @_;
    return unless $valid_types{$type} and $self->$type();
}

sub any_type_name {
    my $self = shift;
    for (@valid_types) {
        return $_ if $self->$_()
    }
    return
}

sub any {
    my $self = shift;
    for (@valid_types) {
        return $self->$_() if $self->$_()
    }
    return
}

sub repo_url {
    'https://github.com/perl6/marketing/tree/master/' . shift->base
}

sub new_request_url {
    my $self = shift;
    'https://github.com/perl6/marketing/issues/new?title='
        . url_encode 'Request for ID# ' . $self->id . ' / ' . $self->title
}

1;
