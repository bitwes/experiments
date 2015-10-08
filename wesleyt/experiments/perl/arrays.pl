!#/usr/bin/perl

sub printArray{
    my (@inArray) = @_;
    
    for each my$var (@inArray){
	print $var . "\n";
    }
}

my @ar;

@ar[0] = 'asfd';
@ar[1] = 'something';


printArray(@ar);
