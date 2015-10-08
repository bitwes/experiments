#!/usr/bin/perl

#use strict;
use dne;
use xu_globals;
use somemethods;
use something_else;

our $my_shared_var;
print "Started\n";

my $globals = xu_globals->new();
print "that var = $globals->{hello_world}\n";

say_something();
print("my_shared_var = $my_shared_var\n");
$somemethods::my_shared_var = ", yo mamma was fat";
say_something();
print("my_shared_var = $my_shared_var\n");

print(somemethods::get_something_to_say());

something_else::say_something_else();
say_something();


1;
