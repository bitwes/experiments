#!/usr/bin/perl

use xu_globals;

package use_globals2;

sub set_global2 {
    $xu_globals::global2 = 'use globals 2 set this';
}

sub print_globals {
    print "use_globals2
$xu_globals::global1
$xu_globals::global2
";
}


1;
