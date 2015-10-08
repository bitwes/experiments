#!/usr/bin/perl

#assigns a var to empty string to show that just calling
#this method will evaluate to false.
sub assign_it{
    my $variable = '';
}


my $something;


#show that the falsey value of 0 will cause the eval to 
#hit the or do
eval {
    0;
} or do {
    print "or do for zero\n";
};


#show that 1 will not hit or do
eval {
    1;
} or do {
    print "or do for one\n";
};


#evaluate the assignment as true or false.  If this looks fishy it should,
#but this was done on purpose.
if($something = ''){
    print "true\n";
} else {
    print "false\n";
}


#same as IF statement above but with eval
eval {
    $something = '';
} or do {
    print "did or do for \'\' assignment\n";
};


#Show that having a method that returns false as the last statement
#in an eval will cause the eval to hit the or do
eval {
    assign_it();
} or do {
    print "did or do for assign_it\n";
};


#show that assigning a non empty string is "true"
eval {
    my $another_var = "asdf";  #will not hit or do
} or do {
    print "or do for another_var";
};


#show that checking $@ after eval catches a die.
eval {
    die ("I died and the or do doesn\'t exist");
};

if ($@){
    print "Got an error from DIE:  $@\n";
} else {
    print "I expected to error but I did not.";
}

eval {
    print 'another eval block, what happens to $@?' . "\n";
};

if($@) {
    print "\$\@ is still set ($@)for some reason, this is unexpected\n";
} else {
    print "No error as expected, everything is fine\n";
}
