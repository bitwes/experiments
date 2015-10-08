#/usr/bin/perl



use strict;
#use lib "$ENV{BASHFILES}";
use svn_utils;

print "$0\n";
svn_utils::print_svn_info_hash(svn_utils::get_info('./'));
print "----------------------\n";

print svn_utils::get_revision('./') . "\n";
print "----------------------\n";

print ('first rev = ' . svn_utils::get_first_revision('./') . "\n");
print ('branched rev = ' . svn_utils::get_revision_when_branched('./') . "\n");
svn_utils::print_changes_since_branch_copy_or_last_revision('./');
print "----------------------\n";
