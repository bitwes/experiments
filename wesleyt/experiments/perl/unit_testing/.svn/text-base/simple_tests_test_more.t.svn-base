#!/usr/bin/perl
use diagnostics; # this gives you more debugging information
use warnings;    # this warns you of bad practices
use strict;      # this prevents silly errors
use Test::More qw( no_plan ); # for the is() and isnt() functions

my $class = 'bioinformatics';

is($class, 'bioinformatics', 'We are in bioinformatics!');
isnt($class, 'microbiology', 'We are not in microbiology!');
is($class, 'microbiology', 'This test case should fail...see why?');

ok(1 == 1, "One should equal one");
ok (1 == 2, "One should not equal two");

sub test_something{
    is("a", "b", "a does not equal b");
}

subtest 'Should run on its own' => sub{
   ok 1, "this assertion passed";
   is("asdf", "ASDF", 'Should fail since case does not match') or diag("here is the diagnostic message");

};

test_something();
