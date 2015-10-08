#!/usr/bin/perl
 
use Net::SFTP;
use strict;

my $host = "host.ssh.com";
my %args = (
    user => 'your_user_name',
         password => 'your_password',
         debug => 'true'
);
my $sftp = Net::SFTP->new($host, %args);
$sftp->get("/home/user/something.txt", "/home/user/hey.txt");
$sftp->put("bar", "baz");
