#!/usr/bin/perl

use strict;
use lum_set_password_methods;

sub runit{
    my ($username, $password) = @_;
    print("Results for $username\n");
    my ($status, $errormsg, $stuflag, $logons) =
        lum_set_password_methods::_check_ad_account($username);
    print("  status=$status\n" .
          "  error=$errormsg\n" .
          "  stuflag=$stuflag\n" .
          "  logons=$logons\n");
    lum_set_password_methods::process_password_change($password, $username);
}


runit('authstu1', 'Qwert1234');
