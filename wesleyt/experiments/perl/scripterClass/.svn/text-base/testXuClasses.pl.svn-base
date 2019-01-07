#!/usr/bin/perl
#require "$ENV{XU_HOME}/general/xu_package.pl";
require "/home/wesleyt/xu_package.pl";
use XuScriptClass;
use strict;



my $blah = new XuScriptClass();

sub otherTestStuff{
  #Run some stuff through SQL Plus
  print($blah->printAndRunSql("\@testSqlScript.sql"));
  print($blah->runSql("SELECT 'I did it' as other_words FROM DUAL;"));
  print($blah->printAndRunSql("PROMPT Hello World;\nPROMPT Goodbye cruel world."));

  my $result;
  #Run a normal shell command
  #this call prints the command, the results, and returns the results.
  $result = $blah->printCmdAndResults("ls -lha");

  #this command only prints the command, and returns the result.
  $result = $blah->printAndRun("pwd");
  print($result);
}

#Setup production settings
$blah->prodSettings->mailingList("prod mailing list");
$blah->prodSettings->mailingListError("Error mailing list");
$blah->prodSettings->ftpCommand("PROD FTP");


#Setup development settings
$blah->devSettings->mailingList(xu_get_distribution_list("/home/wesleyt/test.dst"));
$blah->devSettings->mailingListError("dev Error mailing list");
$blah->devSettings->ftpCommand("DEVELOPMENT FTP");

$blah->print();

#Set the dbName manually because I don't have the file where
#it is supposed to be...I don't think.  dbName is populated
#by xu_get_db() when the class is instantiated.
$blah->dbName("BANTEST");

#Log Settings
$blah->print();

otherTestStuff();
