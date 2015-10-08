#!/usr/bin/perl
package shpcfgUserClassClass;
use strict;

sub new{
    my ($class) = @_;
    my $self = {
        _comparison => '',
        _userClass => '',
        _options => undef
    };
    bless $self, $class;

    #store the hash by reference
    my %hashVar = ();
    $self->{_options} = \%hashVar;

    return $self;
}

sub comparison{
    my ( $self, $newVal ) = @_;
    $self->{_comparison} = $newVal if defined($newVal);
    return $self->{_comparison};
}


sub userClass{
    my ( $self, $newVal ) = @_;
    $self->{_userClass} = $newVal if defined($newVal);
    return $self->{_userClass};
}

sub option{
    my ($self, $optionName, $newVal) = @_;
    #convert the the by-ref hash back into a varaible.  I think.
    my $hashRef = $self->{_options};

    $hashRef->{$optionName} = $newVal if defined($newVal);
    return $hashRef->{$optionName};
}

sub print{
    my ($self) = @_;
    print "(" . $self->comparison . ")" . $self->{_userClass} . "\n";
    my $hashVar = $self->{_options};
    my $prefix = '';
    my $suffix = '';
    my $val = '';
    for my $key ( keys %$hashVar ) {
        $val = $hashVar->{$key};
        $suffix = '';
        if($val eq 'addkey'){
            $prefix = ' + ';
        }elsif($val eq 'remkey'){
            $prefix = '  -';
        }elsif($val eq 'addgroup'){
            $prefix = '++ ';
        }else{
            $prefix = '   ';
            $suffix = " = $val";
        }
        print " $prefix $key $suffix\n";
    }
}

sub overlayClass{
    my ($self, $overlay) = @_;
    my $hashVar = $overlay->{_options};
    for my $key ( keys %$hashVar ){
        $self->option($key, $hashVar->{$key});
    }
}

#sub firstName {
#    my ( $self, $newVal ) = @_;
#    $self->{_} = $newVal if defined($newVal);
#    return $self->{_};
#}

1;
