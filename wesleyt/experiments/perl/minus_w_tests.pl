#/usr/bin/perl
#I was trying to find out a way to detect unused variables.  
#I thought -w did it, but it doesn't.  There is this:
#http://search.cpan.org/dist/Perl-Critic/
use strict;

my $not_used;
my $is_used;

$is_used = 7;

print "is_used = $is_used\n";
