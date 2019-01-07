#!/usr/bin/perl

#open(STDERR, ">", STDOUT);
open(STDOUT, ">", "stdout.txt");
#open(STDERR, ">", "stdout.txt");
print "hello world\n";

eval{
    `mv doesnotexistfiletofmove.asdf something.txt`;
} or do {
    print $@;
    print "it failed!\n";
};
close STDERR;
close STDOUT;
