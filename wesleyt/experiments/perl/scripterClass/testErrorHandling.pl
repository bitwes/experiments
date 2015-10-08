#!/user/bin/perl                        
use XuScriptClass;                      
use strict;                             

sub printErrorVars{
    print("******************************\n" . 
          "*  \$?:    " . $? . 
        "\n*  \$!:    " . $! . 
        "\n*  \$\@:    " . $@ . 
        "\n*  \$^E:   " . $^E . 
        "\n******************************\n");
}



#----------------------------------------
#  Setup
#----------------------------------------
print("Initial value of error vars\n");                                       
printErrorVars();
my $result;
my $blah = new XuScriptClass();
$blah->dbName("BANTEST");
$blah->print();
print("Post init value of error vars\n");
printErrorVars();


 
#----------------------------------------
#  SQL exception handling
#----------------------------------------
print("SQL error script.  Does EXIT FAILURE\n");
$result = $blah->runSql("\@raise_failure.sql");
printErrorVars();
print($result);

#pass in a number to be used as the error number that will
#populate $?.  The actual value in $? will be the number
#passed to the script * 256.
print("SQL error script.  Does EXIT of some number\n");
$result = $blah->runSql("\@raise_specific_error.sql 1");
printErrorVars();

$result = $blah->runSql("\@raise_specific_error.sql 100");
printErrorVars();

$result = $blah->runSql("\@raise_specific_error.sql -1");
printErrorVars();

print("File does not exist\n");
$result = $blah->printAndRunSql("WHENEVER SQLERROR EXIT FAILURE\n\@file_does_not_exist.dne");
printErrorVars();
print($result);

print("No errors\n");
$result = $blah->printAndRunSql("\@no_error.sql");
printErrorVars();
print($result);



#----------------------------------------
#  Other Exceptions
#----------------------------------------

$result = $blah->printCmdAndResults("asdf");
print("Task 4");
printErrorVars();

print("Task 2\n");
$result = $blah->runSql("\@testSqlScript.sql");
printErrorVars();

$result = $blah->printAndRun("ls -ltr");
print("Task 2.5\n");
printErrorVars();

$result = $blah->printAndRun("asdf");
print("Task 3\n");
printErrorVars();

1;
