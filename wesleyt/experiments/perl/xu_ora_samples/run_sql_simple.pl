#!/usr/bin/perl

# This script illustrates using run_sql_simple and how to handle any errors that may
# happen during execution.

use strict;
require "$ENV{XU_HOME}/general/xu_ora.pm";

my $result = xu_ora::run_sql_simple("select count(1) from spriden;");
print $result;
