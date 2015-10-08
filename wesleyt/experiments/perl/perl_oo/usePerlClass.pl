#!/usr/bin/perl

#This finds PerlClass.pm file using magic
use PerlClass;
use strict;

my $blah = new PerlClass();

$blah->firstName('Bubba');
$blah->lastName('Bobobbrain');
$blah->print();

print($blah->firstName . "-" . $blah->lastName . "\n");
