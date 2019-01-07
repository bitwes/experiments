#/usr/bin/perl

#POC for using a hash of functions/procedures.

#-----------------
#define methods to call
#-----------------
sub print_hello {
    print "Hello ";
}

sub print_world {
    print "World";
}

sub print_something{
    print "@_\n";
}

#-----------------
#Create hash of methods (just the names of the methods in a hash really)
#-----------------
my %hash = (
    hello => 'print_hello',
    world => 'print_world',
    something => 'print_something',
);

#-----------------
#Call the two methods from the hash
#-----------------
&{ $hash{'hello'} }();
&{ $hash{'world'} }();
#this one takes a parameter
&{ $hash{'something'} }('!!!!');
