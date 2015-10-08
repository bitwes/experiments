#!usr/bin/perl

use strict;
use Getopt::Long;

#Parameters
my $g_help_string =
'Valid options
   -h --help 
       Display this help.
   -s --someString
       Assigns a string to a global.
';
my $g_opt_someString = '';

sub process_parameters{
    my $help = '';;

    GetOptions('h|help!' => \$help,               #! = no value, flag
               's|someString=s' => \$g_opt_someString)   #s = string
    or die("Error in command line arguments\n");

    if($help){
        print $g_help_string;
        die("Aborting to show help");
    }
}


process_parameters();
