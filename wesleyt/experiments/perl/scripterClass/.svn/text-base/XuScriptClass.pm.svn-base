#!/usr/bin/perl

package XuScriptClass;
require "$ENV{XU_HOME}/general/xu_package.pl";

use XuScriptVarsClass;
use strict;
#-----------------------------------------------------------------------------
#This class does a bunch of stuff.
#-----------------------------------------------------------------------------



#  ----------------
#  Private
#  ----------------


#-----------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------
sub _setIsDevMode {
    my ($self) = @_;
    if($self->dbName eq 'PROD'){
	$self->isDevMode(0);
    }else{
	$self->isDevMode(1);
    }
}

#  ----------------
#  Public
#  ----------------

#-----------------------------------------------------------------------------
#
#-----------------------------------------------------------------------------
sub new{
    my ($class) = @_;
    my $self = {
	#Default username.
	_dbUsername => 'xuprommgr',
	#Dynamically retrieved password
	_dbPassword => '',
	#Production Settings
	_prodSettings => undef,
	#Dev Settings
	_devSettings => undef,
	#set to _prodSettings or _devSettings.  Set when changing
	#value of _isDevMode.
	_currentSettings => undef,
	#Flag to indicate if in dev or prod mode
	_isDevMode => 1,
	#the name of the database that will be connected to.
	_dbName => undef
    };
    bless $self, $class;
    $self->{_dbName} = xu_get_db();
    $self->{_prodSettings} = new XuScriptVarsClass();
    $self->{_devSettings} = new XuScriptVarsClass();
    $self->loadDbPassword();
    $self->_setIsDevMode();
    return $self;
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
    my $toReturn = '';
    my $passHolder = "NOT SET";
    my $doNotRunWarning = '';
    if($self->dbPassword() ne ''){
	$passHolder = "**********";
    }
    $toReturn = "-------------------------------------\n" . 
                "+  Using the Following Settings  +\n" .
                "inDevMode:       " . $self->{_inDevMode} . "\n" .
		"dbUsername:      " . $self->{_dbUsername} . "\n" .
                "  Password:      " . $passHolder . "\n" .
                "DB Name:         " . $self->{_dbName} . "\n" .
                $self->{_currentSettings}->toString() .
                "\n+  Production Settings  +\n" .
                $self->{_prodSettings}->toString() .
                "\n+  Development Settings  +\n" .
                $self->{_devSettings}->toString() .  
                "-------------------------------------\n";
    
    return $toReturn;
}

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub getSqlCmd{
    my ($self, $script) = @_;
    return  "sqlplus -L -S " . $self->dbUsername . "/" . $self->dbPassword . "\@" . $self->dbName . " <<CMD\n" .
                  $script . " \nCMD\n";
}

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub runSql{
    my ($self, $script) = @_;
    my $toRun = $self->getSqlCmd($script);

    return `$toRun`;    
}

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub printAndRunSql {
    my ($self, $script) = @_; 
    return $self->printAndRun($self->getSqlCmd($script));
}

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub printAndRun{              
    my ($self, $toRun) = @_;
    my $log_cmd = "RUNNING:  " . $toRun;
    my $pass = $self->dbPassword;

    $log_cmd =~ s/$pass/********/;
    print $log_cmd . "\n";      
    return `$toRun`;              
}                               

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub printCmdAndResults{
    my ($self,$toRun) = @_;
    my $result = $self->printAndRun($toRun);
    print($result);
    return $result;
}

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub loadDbPassword {
    my ($self) = @_;
    my $exec_cmd = "grep sqlplus $ENV{HOME}/.netrc | grep xuprommgr | cut -f 6 -d \" \"";
    my $result = `$exec_cmd`;
    chomp($result);
    
    $self->{_dbPassword} = $result;
}


#  ----------------
#  Public Accessors
#  ----------------

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub isDevMode {
    my($self, $flag) = @_;
    my $new_val;

    if (defined($flag)){
	#handle bool, make 1 for true, 0 for false
	if($flag){
	    $new_val = 1;
	}else{
	    $new_val = 0;
	}
        
	$self->{_inDevMode} = $new_val;
	if($new_val){
	    $self->{_currentSettings} = $self->{_devSettings};
	}else{
	    $self->{_currentSettings} = $self->{_prodSettings};
	}
    }
    return $self->{_inDevMode};
}
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub dbUsername{
    my($self, $newVal) = @_;
    $self->{_dbUsername} = $newVal if defined($newVal);
    return $self->{_dbUsername};
}

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub dbPassword{
    my($self, $newVal) = @_;
    $self->{_dbPassword} = $newVal if defined($newVal);
    return $self->{_dbPassword};
}
#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub dbName{
    my($self, $dbName) = @_;
    $self->{_dbName} = $dbName if defined($dbName);
    return $self->{_dbName};
}

#-----------------------------------------------------------------------------
#read only access to _prodSettings, but variables in 
#_prodSettings can be set or got.
#-----------------------------------------------------------------------------
sub prodSettings{
    my ($self) = @_;
    return $self->{_prodSettings};
}

#-----------------------------------------------------------------------------
#same as _prodSettings
#-----------------------------------------------------------------------------
sub devSettings{
    my ($self) = @_;
    return $self->{_devSettings};
}

#  --------------------------------
#  accessors for _currentSettings
#  --------------------------------

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub getMailingList{
    my ($self) = @_;
    return $self->{_currentSettings}->mailingList;
}

#-----------------------------------------------------------------------------
#-----------------------------------------------------------------------------
sub getFtpCommand{
    my ($self) = @_;
    return $self->{_currentSettings}->ftpCommand;
}

#EXAMPLE ACCESSOR (setter and getter)
#sub firstName {
#    my ( $self, $firstName ) = @_;
#    $self->{_firstName} = $firstName if defined($firstName);
#    return $self->{_firstName};
#}

1;
