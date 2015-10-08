#!/usr/bin/perl
#------------------------------------------------------------------------------
#Description
#
#Parameters
my $g_help_string =
'Valid options
   -h
       Display this help.
   -f (required)
       input file.
';
#------------------------------------------------------------------------------


use strict;

my $g_input_file;


#---------------------------------------------------------------------------
#Parses out the parameters passed to the script and sets globals accordingly.
#Dies if it encounteres imvalid argumetnts.
#---------------------------------------------------------------------------
sub process_parameters{
    #counter for looping through params
    my $count = 0;

    while ($count < @ARGV) {
        if ($ARGV[$count] eq "-h") {
            print $g_help_string;
            #short circuit everything and stop script after
            #printing help
            die "Aborted run to display help";
        }elsif ($ARGV[$count] eq "-f") {
	    $count ++;
	    $g_input_file = $ARGV[$count];
        } else {
            print $g_help_string;
            die ("Unknown option:  $ARGV[$count]");
        }

        $count ++;
    }
}

sub trim{
    my ($to_trim) = @_;
    $to_trim =~ s/\s+$//;
    
    return $to_trim;
}


sub process_file{

    open (INPUT_FILE, $g_input_file);
    my $line;
    my $action;
    my $key;
    while(<INPUT_FILE>){
	$line = $_;
	chomp($line);
	$line = trim($line);

	if(index($line, '#') == -1){
	    print "<$line>\n";
	    ($action, $key) = split('=', $line);
	    $action = trim($action);
	    $key = trim($key);

	    print "   $action\n";
	    print "   $key\n";
	}
    }
    close(INPUT_FILE);
}

sub main{
    process_parameters();
    process_file();
}

main();
1;
