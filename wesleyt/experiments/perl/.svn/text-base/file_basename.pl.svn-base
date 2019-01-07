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
use File::Basename;

#----------
#Script Option globals
#----------


#---------------------------------------------------------------------------
#Parses out the parameters passed to the script and sets globals accordingly.
#Dies if it encounteres imvalid argumetnts.
#---------------------------------------------------------------------------
sub process_parameters{
    my $help = '';

    GetOptions('h|help!' => \$help)
    or die("Error in command line arguments.  Use -h to see valid options.\n");

    if($help){
        print $g_help_string;
        die('SHOWHELP');
    }
}

#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
sub some_experiments{
    my $name;
    my $path;
    my $suffix;
    my $to_parse = '/hello/world/dottxt.txt';

    ($name, $path, $suffix) = fileparse($to_parse, '\..*');
    print "$to_parse\n  $name\n  $path\n  $suffix\n";

    $to_parse = '/hello/world/somezip.tar.gz';
    ($name, $path, $suffix) = fileparse($to_parse, '\..*');
    print "$to_parse\n  $name\n  $path\n  $suffix\n";
    ($name, $path, $suffix) = fileparse($to_parse, '\*');
    print "$to_parse\n  $name\n  $path\n  $suffix\n";

}

#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
sub print_mv_command{
    my ($from_dir, $file, $date_pid) = @_;                               
    my ($name, $path, $suffix) = fileparse($file, '\..*');               
    my $cmd = "mv $from_dir/$file " .                                    
        $ENV{XU_LOGS} . '/' . $name . $date_pid . $suffix;               
    print "cmd: $cmd\n";    
}

#---------------------------------------------------------------------------
#Processes script parameters and kicks off script logic.
#---------------------------------------------------------------------------
sub main{
    eval{
        process_parameters();
        some_experiments();
        
        print_mv_command($ENV{UTLFILE}, 'somefile.txt', '__insert_this__');
        print_mv_command($ENV{UTLFILE}, 'somefile.rpt', '__insert_this__');
        print_mv_command($ENV{UTLFILE}, 'somefile.zip', '__insert_this__');
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
