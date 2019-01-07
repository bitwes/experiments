#!/usr/bin/perl

use DBI;


my $dbh = DBI->connect("dbi:Oracle:bantest", "xuprommgr", "8855_Pro!");
my $sth =  $dbh->prepare("Select count(1) from spriden");
$sth->execute;
DBI::dump_results($sth);

#create or replace function call_me_from_perl(in_value in varchar2)return varchar2
#is
#begin
#    return '****'||in_value||'****';
#end;

my $ret_val = "overwrite_me";
my $pass_val = "I passed this in";
$sth = $dbh->prepare(q{BEGIN
                       :return_value := call_me_from_perl(:parameter);
                       END;
});

$sth->bind_param_inout(":return_value", \$ret_val, 0);
$sth->bind_param(":parameter", $pass_val);
$sth->execute;
print "ret_val = $ret_val\n";
