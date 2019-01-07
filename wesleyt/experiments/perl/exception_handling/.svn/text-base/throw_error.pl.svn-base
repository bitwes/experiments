#!/usr/bin/perl

use strict;
use err;
$err::Exceptions{'local_error'} = 'This is a localy defined error';


eval{
    die("This error wasn't processed with err");
}or do {
    print $@;
};

eval{
    die($err::e_user_not_found);
} or do {
    print('Error = ' . err::get_error_message($@) . "\n");
    print(err::get_error_line_number(). "\n");
};


eval{
    die("This is some error that happened.");
} or do {
    print('Error = ' . err::get_error_message($@) . "\n");
    print(err::get_error_line_number() . "\n");
};

eval{
    die('local_error');
} or do {
    print('Error = ' . err::get_error_message($@) . "\n");
};

1;
