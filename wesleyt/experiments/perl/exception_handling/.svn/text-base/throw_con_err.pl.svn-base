#!/usr/bin/perl

use strict;
use more_con_errs;
use err;
con_err::add_exception('local_error', 'This is a localy defined error');
con_err::add_exception('local_error', 'This is redefined');
eval{
    die(more_con_errs::E_MEANINGFUL_ERROR);
} or do {
    print(con_err::get_message($@) . "\n");
};

eval{
    die("This is some error that happened.");
} or do {
    print('Error = ' . con_err::get_message($@) . "\n");
};

eval{
    die('local_error');
} or do {
    print('Error = ' . con_err::get_message($@) . "\n");
};



1;
