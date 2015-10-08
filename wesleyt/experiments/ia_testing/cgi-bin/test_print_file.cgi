#!/usr/bin/perl


use strict;

require "http_subs_xu.pl";

sub print_page{

    my %replace_vals = ();
    $replace_vals { 'val1' } = 'REPLACED';

    print("<html>\n");
    print("<head>\n");
    print("</head>\n");
    print("<body>\n");
    print("</body>\n");
    print_file("../test_print_file.html",
               %replace_vals);
    print_file("../test_print_file.html");
    print("</html>\n");
    1;
}



print_page();

1;
