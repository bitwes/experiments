#/usr/bin/perl


use strict;
use Getopt::Long;
use lib $ENV{BASHFILES};
use svn_utils;


my $g_help_string =
'Valid commands
   -h
     display this help
   -what_changed
     Displays all the changes made to the current directory stopping on 
     a copy.
   -list_branches
    list all the branches that currently exist.
   -get_substr_repo
';
#---------------------------------------------------------------------------
#Parses out the parameters passed to the script and sets globals accordingly.
#Dies if it encounteres imvalid argumetnts.
#---------------------------------------------------------------------------
sub process_parameters{
    #counter for looping through params
    my $count = 0;

     if(@ARGV == 0){
        print $g_help_string;
        die "Must provide a valid option";
    }

     while ($count < @ARGV) {
        if ($ARGV[$count] eq "-h") {
            print $g_help_string;
            #short circuit everything and stop script after
            #printing help
            die "Aborted run to display help";
        }elsif ($ARGV[$count] eq "-what_changed") {
            cmd_what_changed();       
        }elsif ($ARGV[$count] eq "-list_branches") {
            cmd_list_branches();
        }elsif ($ARGV[$count] eq "-get_substr_repo") {
            cmd_get_subtr_repo();
        } else {
            print $g_help_string;
            die ("Unknown option:  $ARGV[$count]");
        }

        $count ++;
    }
}

#---------------------------------------------------------------------------
#
#---------------------------------------------------------------------------
sub cmd_what_changed{
    svn_utils::print_changes_since_branch_copy_or_last_revision('./');
}

#---------------------------------------------------------------------------
#
#---------------------------------------------------------------------------
sub cmd_list_branches{
    my $url = 'http://svn/branches';
    my $branches = `svn ls $url`;
    
    my @lines = split /\n/, $branches;
    foreach my $line (@lines) {
        print "$url/$line\n";
    }

}

#---------------------------------------------------------------------------
#
#---------------------------------------------------------------------------
sub cmd_get_subtr_repo{
    my $url = `svn info 2>/dev/null| grep "URL:"`;
    if(length($url) > 0){
        $url = substr($url, 15);

        if(length($url) > 20){
            my @parts = split('/', $url);
            my $substringed = "";
            my $i = 0;

            if(scalar @parts > 3){
                #get the first 2 parts of the path.  
                while($i < scalar @parts and $i < 3){
                    $substringed = $substringed . $parts[$i] . '/';
                    $i += 1;
                }
                #add in the last one with a nice ellipsis
                $url = $substringed . '.../' . $parts[scalar @parts -1];
            }
        }
        print $url
    }
}

sub main{
    process_parameters();
}

main;
