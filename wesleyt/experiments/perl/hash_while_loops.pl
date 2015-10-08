#!/usr/bin/perl

#Because of the way perl knows where it is in the list of a hash's keys
#when in a while loop, odd things can happen if a while loop is exited
#prematurely.
use strict;

my %coins = ( "Quarter" , 25,
           "Dime" ,    10,
           "Nickel",    5 );

#print out all the values
print("Here are all the values in the hash\n");
while (my ($key, $value) = each(%coins)){
  print("key = $key\n");
}


#start a while loop that dies on the first iteration.  This will cause th internal
#marker that perl keeps to stay where it was when the loop died.
eval{
    while (my ($key, $value) = each(%coins)){
        die("This will cause the next while loop to start where this one left off");
    }
} or do {
    print "$@\n";
};

print("All But first value, because last loop died:  \n");
#because the first while died, this one will start with the 2nd key in the hash and
#print out all but the first value.
while (my ($key, $value) = each(%coins)){
  print("key = $key\n");
}


print("\nillustrate that nested while loops on the same hash are infintie.\n");
my $counter = 0;
while (my ($key, $value) = each(%coins)){
    print("outer key = $key\n");
    if($counter > 5){
        die("The counter reached 5 and never should because there is only 3 items in the hash");
    }
    while (my ($key, $value) = each(%coins)){
        print("    inner key = $key\n");
    }
    $counter += 1;
}

1;
