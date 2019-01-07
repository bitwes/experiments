#!/usr/bin/perl
#Here we are exporting the method say_something for use in other
#files.  We are also sharing the variable my_shared_var for
#use in other files.  Since there is a package here, the methods
#must be prefixed with the somemethods::

use strict;
use Exporter;

package somemethods;


our @ISA = ('Exporter');
our @EXPORT = qw(say_something);
our $my_shared_var = "something";

sub say_something{
    print(get_something_to_say());
}

sub get_something_to_say{
    return "Said $my_shared_var\n";
}

1;
