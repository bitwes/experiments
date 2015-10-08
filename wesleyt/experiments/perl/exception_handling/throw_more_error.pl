#!/usr/bin/perl

use strict;
use more_err;

eval{
    die($more_err::e_more_error);
} or do {
    print("huh?  $more_err::dne");
    print('Error = ' . err::get_error_message($@) . "\n");
    print(err::get_error_line_number() . "\n");
};



1;
