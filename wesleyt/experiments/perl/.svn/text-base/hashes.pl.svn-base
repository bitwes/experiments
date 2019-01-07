#!/usr/bin/perl

use strict;

my %hash = ();
my $key = "var_key";
my $value = "var_value";

$hash { 'something' } = 'nothing';
$hash { 'one' } = '1';
$hash { '2' } = 'two';
$hash { $key } = $value;


print("For loop \n");
for (keys %hash){
    print($_ . " = " . $hash{$_} . "\n");
}

print("\nWhile loop \n");
while ( my ($key, $value) = each(%hash) ) {
    print "$key => $value\n";
}

print("\nAnother for loop\n");
for my $key ( keys %hash ) {
    my $value = $hash{$key};
    print "$key => $value\n";
}
