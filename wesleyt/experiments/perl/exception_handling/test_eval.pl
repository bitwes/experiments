#!/usr/bin/perl

use strict;

#prints, $@ is null
eval { 
    1 == 2;
} or print "--$@ __One does not equal two\n";

#does not print since this is true;
eval {
    1 == 1;
} or print "--$@ __One should equal one but it blew chow\n";

#prints, $@ is populated with the "It died"
eval {
    die("It died");
} or print "--$@ __DIE\n";

#prints, $@ is null
eval {
    0;
} or print "--$@ __Zero again\n";

#does not print
eval {
    1;
} or print "--$@ __ONE! \n";



my $number;

#does not print the 'or print' and number = 10
$number = eval { 5+5 } or print ("--$@ __ten\n");
print "Number = $number\n";

#prints the 'or print' and number = 0
$number = eval { 5-5 } or print ("--$@ __subtract to zero\n");
print "Number = $number\n";


sub return_zero{
    return 0;
}

sub return_one{
    return 1;
}

#prints b/c last statement retutns 0, illustrating that 
#you have to be careful of what the last satement is
#in your eval.
eval{
    $number = 44;
    return_zero();
}or do{
    print("it returned zero so we printed and \$\@ is null ($@)\n");
};

#does not print since last statement is 'true'
eval{
    $number = 55;
    return_zero();
    return_one();
}or do{
    print("THIS SHOULDN'T PRINT");
};
