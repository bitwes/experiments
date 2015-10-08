#!/usr/bin/perl
#------------------------------------------------------------------------------
# Description
# This is the description of what this script does and where it is called from
# should reference wiki page.
#
# Options
my $g_help_string =
'Valid options
   -h --help
       Display this help.
   -t --table-to-count
       An option for illustration purposes.  Used by some_method to 
       determine what table to count.  Default is stvterm.
';
#
# History
# 01/01/11 [username]     [TDxxxxxx] or [project name]
#  The description of the change goes here.  If it spans more than one line 
#  thenit continues indented.
#------------------------------------------------------------------------------

use strict;
use Getopt::Long;
use lib ("$ENV{XU_HOME}/general");
use xu_common;
use xu_ora;

#----------
#Script Option globals
#----------
my $g_opt_table_to_count = 'stvterm';

#---------------------------------------------------------------------------
#Parses out the parameters passed to the script and sets globals accordingly.
#Dies if it encounteres imvalid argumetnts.
#---------------------------------------------------------------------------
sub process_parameters{
    my $help = '';

    GetOptions('h|help!' => \$help,
               't|table-to-count=s' => \$g_opt_table_to_count)
    or die("Error in command line arguments.  Use -h to see valid options.\n");

    if($help){
        print $g_help_string;
        die('SHOWHELP');
    }
}

#----------------------------------------------------------------------------
#Description
#
#Parameters
#  parm1
#  parm2
#
#Return
#  Return value description
#----------------------------------------------------------------------------
sub some_method{
    #illustartion and ensures that libraries are included properly.
    print("\nTIMESTAMP:  " . xu_common::timestamp_mmddyyyy() . "\n\n");
    print("Counting $g_opt_table_to_count\n" . xu_ora::run_sql("Select count(1) from $g_opt_table_to_count;"));
}

#---------------------------------------------------------------------------
#Processes script parameters and kicks off script logic.
#---------------------------------------------------------------------------
sub main{
    eval{
        process_parameters();
        some_method();
        1; #ensure last method called doesn't send us into 'or do' accidentally
    } or do {
        my $error = $@;
        #ignore the show help error that is raied by process_parameters.
        if(!($error =~ /^SHOWHELP/)){
            #add in some error handling here.
            die($error);
        }
    };
}

main();
1;
