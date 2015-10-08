#!/user/bin/perl

require "$ENV{XU_HOME}/general/xu_ora.pm";
use strict;

#-------------------------------------------------------------------------------
# Some initializations
#-------------------------------------------------------------------------------
sub init{
    print("------------init------------\n");
    xu_ora::set_print_commands_off();
    xu_ora::set_serveroutput_off();
    eval{
        xu_ora::run_script('create_sfp_sample.sql');
    } or do {
        print 'SFP_SAMPLE_TABLE probably already exists.';
    };
    eval {
        xu_ora::run_sql("begin\ndelete from sfp_sample_table\;  commit\;\nend;/");
    } or do {
        print ("Something bad happened.\n\n$@");
        die;
    };
    print("\n------------init------------\n\n\n");
}

#-------------------------------------------------------------------------------
# Prints a seperator
#-------------------------------------------------------------------------------
sub _print_sep{
    my ($text) = @_;
    my $line = '__________________________________________________';

    if($text){
        print " $line\n";
        print "|$text";
        print "\n|$line\n";
    } else {
        print "_$line\n";
    }
}

#-------------------------------------------------------------------------------
# Examples of using run_sqlldr
#-------------------------------------------------------------------------------
sub run_some_sqlldr{
    _print_sep('Errors on a bad input file defined in ctl file');
    #this one doesn't specify the data option, and infile (in the .ctl file) is
    #set to a file that does not exist so this will error.
    eval{
        print xu_ora::run_sqlldr("CONTROL=sqlldr_test_control.ctl");
    } or do {
        print "\nThere was an error\n\n$@";        
    };

    _print_sep('sqlldr, everything works fine');
    #this one should work just fine.
    eval{
        print xu_ora::run_sqlldr("CONTROL=sqlldr_test_control.ctl DATA=sqlldr_test_data.txt LOG=sqlldr_works.log");
        print xu_ora::run_sql("select count(1) from SFP_SAMPLE_TABLE\;");
    } or do {
        print ("UNEXPECTED ERROR:  $@");
    };
    
    _print_sep('sqlldr, errors on bad option');
    #invalid option sent to sqlldr
    eval{
        print xu_ora::run_sqlldr("ASDF=asdf CONTROL=sqlldr_test_control.ctl");
    } or do {
        print "\nThere was an error\n\n$@";        
    }
}

#-------------------------------------------------------------------------------
# Examples of using run_sql and run_script
#-------------------------------------------------------------------------------
sub run_some_sql{
    _print_sep('run_sql, successful query.');
    #example of running a sql statement that works.
    print xu_ora::run_sql('select count(1) from spriden;');

    _print_sep('xu_ora::run_sqlplus, Catch Oracle error');
    #Example of catching an Oracle error, the table in this
    #select statement does not exist.
    eval{
        print xu_ora::run_sql('select count(1) from table_dne_table_table;');
    } or do {
        print "\nThere was an error\n\n$@";
    };

    _print_sep('xu_ora::run_sql, file does not exist.');
    #Example of catching a sql plus error.  This file does not
    #exist so an SP2 error is raised and detected by xu_ora::run_sql
    #which in turn causes a die.
    eval{
        print(xu_ora::run_sql("\@no_file_here.sql"));
        print("! should have errored !\n");
    } or do {
        print "\nThere was an error\n\n$@\n";
    };

    _print_sep('xu_ora::run_script, file does not exist.');
    #Example of trying to run a SQL file using xu_ora::run_script when the
    #file does not exist.  This causes a different error than running
    #a file with xu_ora::run_sql since we know we are trying to run a file,
    #the error is thrown sooner by xu_ora::run_script instead of detecting
    #the SP2 error.
    eval{
        print(xu_ora::run_script("no_file_here.sql"));
        print("! should have errored !\n");
    } or do {
        print "\nThere was an error\n\n$@\n";
    };    

    _print_sep('xu_ora::run_script, file exists but does not end in /');
    #Run a file in sqlplus that exists but does not end in a 
    #forward slash.  This will print an error message but still
    #executes the file.  xu_ora::run_sql does not perform this check.
    eval{
        print(xu_ora::run_script("sample_query.sql"));
    } or do {
        print "\nThere was an error\n\n$@\n";
    };

    _print_sep('xu_ora::run_sql, run plsql procedure');
    #example of calling a plsql procedure.  Note, it must be a procedure
    #because you cannot call functions.  Notice that you do not have to 
    #explicitly set serveroutput on to get the results since it was turned
    #on using xu_ora::set_serveroutput(1).
    eval{
        print(xu_ora::run_sql("exec xu_error.print_code('some_name', -20001, 'some message');"));
    }or do {
        print "\nThere was an error\n\n$@\n";
    };
    
    #Calling using a different user and db.  This actually uses the same user, xuprommgr, since
    #they have to exist in the .netrc file to get the password.  You also must specify the
    #user to specify a different db due to the order of the optional parameters.
    #
    #Also note the way that the select statement is passed in.  It must be single quoted
    #and the $ must be "escaped".  This has to do with the command is passed through the
    #run_sql method to bash.  If it is not single quoted and escaped then run_sql will
    #try to do a substitution for $database.
    _print_sep('xu_ora::run_sql different user and db');
    eval{
        print(xu_ora::run_sql('select name from v\$database;', 'xuprommgr', 'bantest2'));
    } or do {
        print "\nThere was an error\n\n$@\n";        
    };

    #use an invalid username to connect to the db.
    _print_sep('xu_ora::run_sql different, invalid user and valid db');
    eval{
        print(xu_ora::run_sql('select name from v\$database;', 'billy', 'bantest2'));
    } or do {
        print "\nThere was an error\n\n$@\n";        
    };
    

    #the following are examples using run_sql_simple.
    _print_sep('xu_ora::run_sql_simple, query.');
    print xu_ora::run_sql_simple("select count(1) from spriden;");

    _print_sep('xu_ora::run_sql_simple, file does not exist.');
    print xu_ora::run_sql_simple('@no_file_here.sql');

    _print_sep('xu_ora::run_sql_simple, file exists.');
    print xu_ora::run_sql_simple('@sample_query.sql');
}



#===============================================================================
#
#  Begin execution
#
#===============================================================================

init();

xu_ora::set_print_commands_full();
xu_ora::set_serveroutput_on();

run_some_sqlldr();
run_some_sql();

1;
