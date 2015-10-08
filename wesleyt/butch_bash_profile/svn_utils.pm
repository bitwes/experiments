#/usr/bin/perl

use strict;
package svn_utils;

use constant {
    REVISION => 'Revision',
    URL => 'URL',
    REPO_ROOT => 'Repository Root',
    LAST_CHANGED_REV => 'Last Changed Rev',
};


#---------------------------------------------------------------------------
#print a hash
#---------------------------------------------------------------------------
sub print_svn_info_hash{
    my(%hash) = @_;
    while ( my ($key, $value) = each(%hash) ) {
        print "$key = '$value'\n";
    }
}

#---------------------------------------------------------------------------
#Returns a hash containing all the info from a `svn info`
#---------------------------------------------------------------------------
sub get_info{
    my ($repo) = @_;

    #Create hash that has all the keys we are looking for in
    #in the results of svn info
    my %info;
    $info{(REVISION)} = '';
    $info{(URL)} = '';
    $info{(REPO_ROOT)} = '';
    $info{(LAST_CHANGED_REV)} = '';

    my $svn_info = `svn info $repo`;
    my $garbage;
    my $temp_val;
    
    #assign the values to the hash by looping through each line looking 
    #to see each key is there.  If it is, assign the value parsed out,
    #otherwise assign the current value.
    my @lines = split /\n/, $svn_info;
    foreach my $line (@lines) {
        while ( my ($key, $value) = each(%info) ) {
            ($garbage, $temp_val) = split("$key: ", $line);
            $info{$key} = $temp_val || $value;
        }
    }

    return %info;
}

#---------------------------------------------------------------------------
#gets the svn revision number for the current directory.
#---------------------------------------------------------------------------
sub get_revision{
    my ($repo) = @_;
    
    my %hash = get_info($repo);

    return $hash{(REVISION)};
}

#---------------------------------------------------------------------------
#Returns the revision number where a branch was created.  This must be run
#from within a svn branch directory.
#---------------------------------------------------------------------------
sub get_revision_when_branched{
    my ($repo) = @_;
    #spit out the log entry for the revision where the branch was 
    #created and then only return the line that starts with the 
    #letter 'r' since that is the line that displays the revision.
    my $rev = `svn log $repo -v -r0:HEAD --stop-on-copy --limit 1 | grep '^r'`;
    
    #substring out the revision number.  
    my $pipe_loc = index $rev, '|';
    $rev = substr($rev, 1, $pipe_loc - 2); #-2 b/c there is a space after the num
    chomp $rev;
    
    return $rev ;   
}

#---------------------------------------------------------------------------
#same as when branched but doesn't stop on copy.
#---------------------------------------------------------------------------
sub get_first_revision{
    my ($repo) = @_;
    my $rev = `svn log $repo -v -r0:HEAD --limit 1 | grep '^r'`;    
    my $pipe_loc = index $rev, '|';
    $rev = substr($rev, 1, $pipe_loc - 2); #-2 b/c there is a space after the num
    chomp $rev;
    
    return $rev ;   
}

#---------------------------------------------------------------------------           
#Gets the full URL for the trunk of a branch.                                                          
#---------------------------------------------------------------------------           
sub get_branch_trunk_and_revision{                                                                  
    my ($branch_url) = @_;                                                             
                                                                                       
    my $to_return = `svn log --verbose --stop-on-copy $branch_url | grep \"(from\"`;  
    chomp $to_return;                                                                 
    my $open = index ($to_return, '(from ') + 6; #+6 b/c length of '(from '
    my $close = index($to_return, ')', $open) - $open;  #- $open b/c substr wants length
    $to_return = substr($to_return, $open, $close);

    my %info = get_info($branch_url);
    $to_return = $info{(REPO_ROOT)} . $to_return;

    return  $to_return;
}                                                                                      

#---------------------------------------------------------------------------           
#---------------------------------------------------------------------------           
sub get_what_changed{
    my ($starting_rev, $ending_rev, $svn_url) = @_;
    my $diff_cmd = "svn diff --summarize -r${starting_rev}:${ending_rev} ${svn_url}";   
    print $diff_cmd . "\n";
    my $diff_results = `$diff_cmd`;    

    my $opflag;
    #loop through the lines of the diff results assessing what
    #change occurred and how to handle it.
    my @lines = split /\n/, $diff_results;
    foreach my $line (@lines) {
        #print $line . "\n";
        $opflag = substr($line, 0, 1);

        #the number 8 accounts for the opflag and spaces after
        #the opflag, then we add the length of the url
        #to get the base file name
        #$relative_file_path = substr($line, 8 + length($svn_url));
        #$local_file = $g_staging_dir . "/code" . $relative_file_path;
        #$remote_file = substr($line, 7);

        #print $line . "\n";

        #add deleted files to the array so the rm command can be
        #added later and get the file from the repo for any new
        #or any changed file.
        if($opflag eq 'D'){
            #$delete_files[$del_idx] = $relative_file_path;
            #$del_idx ++;
        }elsif ($opflag eq 'A' || $opflag eq 'M'){
            #make_path($local_file);
            #`svn export $remote_file $local_file`;
            #$did_add_or_modify_files = 1;
            print $line . "\n";
        }
    }
}


#---------------------------------------------------------------------------
#---------------------------------------------------------------------------
sub print_changes_since_branch_copy_or_last_revision{
    my ($repo) = @_;
    my %info = get_info($repo);
    my $branched_rev = get_revision_when_branched($repo);
    my $first_rev = get_first_revision($repo);

    my $ending_rev = $info{(REVISION)};
    my $starting_rev;
    
    if($first_rev != $branched_rev){
        $starting_rev = $branched_rev;
        print "Getting branch changes\n";
    }else{
        $starting_rev = $ending_rev - 1;
        print "Getting differences in revisions $starting_rev/$ending_rev\n";
    }

    my $cmd =  "svn diff --summarize -r${ending_rev}:${starting_rev} $repo";

    print "diff\n" . `$cmd` . "local\n" . `svn status` ;
}


1;
