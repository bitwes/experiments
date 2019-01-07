#!/usr/bin/perl
package err;

use strict;

our $e_user_not_found     = 'e_10010';
our $e_invalid_port       = 'e_10011';
our $e_id_10_t            = 'e_10012';


our %Exceptions = ();
$Exceptions{$e_user_not_found} = 'The user was not found in there';
$Exceptions{$e_invalid_port}   = 'The port you wanted to use could not be used because it does not ' .
                                 'want to be used for some reason.';
$Exceptions{$e_id_10_t}        = 'This is an ID-10-T error.  I is not my fault, it is yours.';

my $last_message;
my $last_line_number;

sub _set_locals{
    my ($error) = @_;
    $last_message = substr($error, 0, rindex($error, "at") - 1);
    $last_line_number = substr($error, rindex($error, "at"));
    chomp($last_message);
    chomp($last_line_number);
}

sub get_error_message{
    my ($error) = @_;
    if($error){
	_set_locals($error);
    }
    return $Exceptions{$last_message} || $last_message;
}

sub get_error_line_number{
    my ($error) = @_;
    if($error){
	_set_locals($error);
    }
    return $last_line_number;
}

1;
