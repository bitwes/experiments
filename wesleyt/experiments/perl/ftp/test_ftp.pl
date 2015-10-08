#!/usr/bin/perl

use Net::FTP;

sub nocftp01PutFile{
    my ($filename, $putFilename) = @_;
    my $ftp;

    eval{
	$ftp = Net::FTP->new("nocftp01.xu.edu", Debug => 0) 
	    or die "Cannot connect to server";
	$ftp->login("ftpuser")
	    or die "Cannot login ", $ftp->message;
	$ftp->put($filename , $putFilename)
	    or die "put failed ", $ftp->message;
	$ftp->quit;
	1
     } or do {
	 if($ftp != null){
	     $ftp->message;
	 }else{
	     $@;
	 }
     }
}

sub nocftp01GetFile{
    my ($filename, $putFilename) = @_;
    my $ftp;

    eval{
	$ftp = Net::FTP->new("nocftp01.xu.edu", Debug => 0) 
	    or die "Cannot connect to server";
	$ftp->login("ftpuser")
	    or die "Cannot login ", $ftp->message;
	$ftp->get($filename)
	    or die "put failed ", $ftp->message;
	$ftp->quit;
	1
     } or do {
	 #constructor could fail, this causes ftp to be null
	 #and the die fills $@.
	 if($ftp != null){
	     $ftp->message;
	 }else{
	     $@;
	 }
     }
}

my $ftpResult = nocftp01PutFile("file_to_put.txt", "file_to_get.txt");
if($ftpResult != 1){
    print $ftpResult;
}

$ftpResult = nocftp01GetFile("file_to_get.txt");
if($ftpResult != 1){
    print $ftpResult;
}

print "finished\n";
