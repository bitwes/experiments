#!/usr/bin/perl
#This is an attempt to use an OO Class in Perl.  Information about 
#OO in perl was found ata http://www.codeproject.com/KB/perl/camel_poop.aspx

package PerlClass;
use strict;

#constructor
sub new{
    my ($class) = @_;
    my $self = {
        _firstName => undef,
	_lastName => undef
    };
    bless $self, $class;
    return $self;
}

sub print {
    my ($self) = @_;

    print($self->firstName . "\n");
    print($self->lastName . "\n");
}

#accessor method for Person first name
sub firstName {
    my ( $self, $firstName ) = @_;
    $self->{_firstName} = $firstName if defined($firstName);
    return $self->{_firstName};
}

#accessor method for Person last name
sub lastName {
    my ( $self, $lastName ) = @_;
    $self->{_lastName} = $lastName if defined($lastName);
    return $self->{_lastName};
}

1;
