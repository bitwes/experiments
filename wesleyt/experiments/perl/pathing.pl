use Cwd 'abs_path';
print '$0 = ' . "$0\n";
print 'abs $0 = ' . abs_path($0) . "\n";

print '$1 = ' . "$1\n";
#turns out this is the same as null.  Not sure where I found this
#or if I inferred that $1 would be something different since $0 is 
#is something.  $0 is the name of the file being run, $1 is one of the 
#regex variables, so since we haven't done any regex yet, $1 is null 
#(as is evident from all the concat warnings you get when your un this)
print 'abs $1 = ' . abs_path($1) . "\n";
print 'abs null = ' . abs_path("") . "\n";

#if you want the path to a file in the same directory as the running
#file then this is how you do it.
print 'abs asdf.txt = ' . abs_path("asdf.txt") . "\n";
