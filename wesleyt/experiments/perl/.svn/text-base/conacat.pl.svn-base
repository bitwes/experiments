#/usr/bin/perl

use strict;

sub assign_it{
    my $variable = '';
}


sub print_concat_asdf{
    my ($chars) = @_;
    print $chars . " asdf\n";
}


my $something;

print_concat_asdf('');
print_concat_asdf("");
print_concat_asdf($something);

$something = "";
print_concat_asdf($something);

$something = '';
print_concat_asdf($something);

$something = undef;
print_concat_asdf($something);

print_concat_asdf("poop");


if($something = ''){
    print "true\n";
} else {
    print "false\n";
}


eval {
    $something = '';
} or do {
    print "did or do\n";
};


eval {
    assign_it();    
} or do {
    print "did or do for assign as well\n";
};


eval {
    0;
} or do {
    print "or do for zero\n";
};

eval {
    my $another_var = "asdf";
} or do {
    print "or do for another_var";
};
print "DONE\n";


