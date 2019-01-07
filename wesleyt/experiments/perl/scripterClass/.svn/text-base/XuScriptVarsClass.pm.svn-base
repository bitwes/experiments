#!/user/bin/perl
package XuScriptVarsClass;
use strict;


#---------------------------------------------------------------
#This class holds all of the settings that are common between
#production and development environments.  This is more like a
#struct in that it has no real functionality, it's just a 
#container for values.
#---------------------------------------------------------------


#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub new{
    my ($class) = @_;
    my $self = {
        _mailingList => undef,
	_mailingListError => undef,
        _ftpCommand => undef
    };
    bless $self, $class;
}

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub print{
    my ($self) = @_;

    print($self->toString());
}

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub toString{
    my ($self) = @_;

    return "Mailing List:    " . $self->{_mailingList} . "\n" . 
           "Error Mailing List:  " . $ self->{_mailingListError} . "\n" .
           "FTP Command:     " . $self->{_ftpCommand} . "\n";
}

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub mailingList{
    my ($self, $mailList) = @_;
    $self->{_mailingList} = $mailList if defined($mailList);
    return $self->{_mailingList};
}

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub mailingListError{
    my ($self, $newVal) = @_;
    $self->{_mailingListError} = $newVal if defined($newVal);
    return $self->{_mailingListError};
}

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub ftpCommand{
    my ($self, $ftpCommand) = @_;
    $self->{_ftpCommand} = $ftpCommand if defined($ftpCommand);
    return $self->{_ftpCommand};
}

1;
