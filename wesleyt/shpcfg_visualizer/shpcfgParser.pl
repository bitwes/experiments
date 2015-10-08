#!/user/bin/perl

use strict;
use shpcfgUserClassClass;
use constant DGWUC => 'DGWUSERCLASS';

my $gCurrentClass = undef;
my $gEveryone = undef;
my @gFoundUserClasses = undef;
my @gNotEqualUserClasses = undef;
my @gUnknownUserClasses = undef;


#-------------------------------------------
#-------------------------------------------
sub trim($)
{
    my ($string) = @_;

    #strip leading and trailing white space
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    
    return $string;
}

#-------------------------------------------
#-------------------------------------------
sub setNewClassFromLine{
    my ($line) = @_;
    my $found = 0;
    my $comparison = '_?_';
    my $value = '_?_';
    my $newClass = undef;

    #print "Matching \"$line\" \n";

    #remove the double quotes that appear in the comparison
    $line =~ s/[\"]*//g;

    #match "if" with no comparison
    #                 |---$1----|
    if($line =~ m/if\(([a-zA-Z]*)\)/){
        $comparison = '=';
        $value = $1;
        $found = 1;
    }

    #match if with comparison
    #                 |---$1----||--$2--||---$3----|
    if($line =~ m/if\(([a-zA-Z]*)([=<>]*)([a-zA-Z]*)\)/){
        my $left = $1;
        my $right = $3;
        $comparison = $2;
        if($left eq DGWUC){
            $value = $right;
        }elsif($right eq DGWUC){
            $value = $left;
        }
        $found = 1;
    }

    if($found){
        #used a local to create the new one so that I 
        #didn't keep pushing references to gCurrentClass
        #into the arrays.
        $newClass = new  shpcfgUserClassClass;
        $gCurrentClass = $newClass;
        $gCurrentClass->comparison($comparison);
        $gCurrentClass->userClass($value);
        
        if($gCurrentClass->userClass eq 'EVERYONE'){
            $gEveryone = $newClass;
        }elsif ($gCurrentClass->comparison eq '<>'){
            push(@gNotEqualUserClasses, \$newClass);
        }elsif ($gCurrentClass->comparison eq '='){
            push(@gFoundUserClasses, \$newClass);
        }else{
            push(@gUnknownUserClasses, \$newClass);
        }        
    }
    return $found;
}

#-------------------------------------------
#-------------------------------------------
sub addOptionFromLine{
    my ($line) = @_;
    return if not defined($gCurrentClass);
    $line =~ s/[\s]*//g;
    
    if($line =~ m/([a-zA-Z]*)\=([0-9a-zA-Z]*)/g){
        if($1 eq 'addkey' || $1 eq 'remkey' || $1 eq 'addgroup'){
            $gCurrentClass->option($2, $1);
        }else{
            $gCurrentClass->option($1, $2);
        }
    }
}

#-------------------------------------------
#-------------------------------------------
sub parseFile{
    my $FILE;
    my $line;

    open FILE, "<", "./SHPCFG" or die $!;
    while($line = <FILE>){
        #remove all spaces to make regex simpler.
        $line =~ s/[\s]*//g;
        if($line !~ /^\#/){
            if(!setNewClassFromLine($line)){
                addOptionFromLine($line);
            }
        }
    }
    close (FILE);
}

#-------------------------------------------
#-------------------------------------------
sub testStuff{
    my $cls = new shpcfgUserClassClass;
    $cls->userClass("SomeClassUGotHere");
    $cls->comparison("=");
    $cls->option("One", "The number 1");
    $cls->option("Two", "The number....two!");
    $cls->option("One", "Overwroten!!");
    $cls->print();

    print ($cls->option("Three")); #prints error, unitiialized string
    print ($cls->option("Four"));  #this line does the same
    print ($cls->option("Two"));
}


#-------------------------------------------
#-------------------------------------------
sub printUserClassArray{
    my (@arr) = @_;

    foreach my $blah (@arr){
        if(defined($blah)){
            $$blah->print();
        }else{
            print "it no be defined:  $blah\n";
        }
    }
}

#-------------------------------------------
#-------------------------------------------
sub combineUserClass{
    #3 parameters, the last is an array.  since all the params
    #come through in an array, we have to shift off the first
    #two and then set the 3rd equal to the rest of them.
    my $baseClass = shift;
    my $everyoneClass = shift;
    my @notEqualClassArray = @_;

    my $toReturn = new shpcfgUserClassClass;
    $toReturn->comparison($$baseClass->comparison);
    $toReturn->userClass($$baseClass->userClass);
    $toReturn->overlayClass($everyoneClass);
    
    foreach my $neClass (@notEqualClassArray){
        if(defined($neClass)){
            $toReturn->overlayClass($$neClass);
        }
    }
    
    $toReturn->overlayClass($$baseClass);
    return $toReturn;
}

#-------------------------------------------
#-------------------------------------------
sub testIfParser{
    setNewClassFromLine('if(' . DGWUC .  '  = asdf)   ');  # = asdf
    setNewClassFromLine('if     (cdef   )');         # = cdef
    setNewClassFromLine('   if(   cdef)   ');         # = cdef
    setNewClassFromLine('   if ( that <> ' . DGWUC . ')');
}

#-------------------------------------------
#-------------------------------------------
sub printUserClassGlobals{
    print( "*** EVERYONE User Class ***\n");
    $gEveryone->print();
    
    print( "\n*** Found User Classes ***\n");
    printUserClassArray(@gFoundUserClasses);

    print( "\n*** Not EQ User Classes ***\n");
    printUserClassArray(@gNotEqualUserClasses);
    
    print( "\n*** Uncatogorized User Classes ***\n");
    printUserClassArray(@gUnknownUserClasses);
}

sub printCombinedUserClasses{
    my $combinedClass = undef;

    print( "*** EVERYONE User Class ***\n");
    $gEveryone->print();

    print( "\n*** Not EQ User Classes ***\n");
    printUserClassArray(@gNotEqualUserClasses);

    print( "\n*** User Classes including settings from Everyone and NE Classes ***\n");

    foreach my $userClass (@gFoundUserClasses){
        if(defined($userClass)){
            $combinedClass = combineUserClass($userClass, $gEveryone, @gNotEqualUserClasses);
            $combinedClass->print();
        }
    }
}

#testIfParser;
parseFile();
printCombinedUserClasses;

