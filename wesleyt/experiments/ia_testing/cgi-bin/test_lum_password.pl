#!/usr/bin/perl


require "lum_set_password_methods.pl";

#should indicate that the passwords do not match.
sub test1{
    eval{
	do_everything('asdf', 'asdx', 'someuser');
	1;
   } or do {
       print("-t1 Should be pass don't match:  ($@)\n");
   };
}


sub test2{
    eval{
	my $stuflag = verify_ad_account_and_get_stuflag('wesleyt');
	1;
    } or do {
	print("-t2 Should be already set:  ($@)\n");
    };
}

sub test3{
    eval{
	my $stuflag = verify_ad_account_and_get_stuflag('noexistperson');
	1;
    } or do {
	print("-t3 Should be not exist:  ($@)\n");
    };
}

sub test4{
    eval{
	my $stuflag = verify_ad_account_and_get_stuflag('authtest1');
	die("stuflag should be set") unless $stuflag;
	print("-t4 Everything is fine\n");
	1;
    } or do {
	print("BAD ERROR:  $@\n");
    };
}

sub test5{
    eval{
	verify_password('asdf', 1);
	print("-t5 FAIL, should have errored");
	1;
    } or do {
	print("-t5 should be invalid length:  $@\n");
    };


    eval{
	verify_password('12345678901234567', 1);
	print("-t5 FAIL, should have errored");
	1;
    } or do {
	print("-t5 should be invalid length:  $@\n");
    };

    eval{
	verify_password('abcd5fghi5', 1);
	print("-t5 everythign is fine\n");
	1;
    } or do {
	print("-t5 FAIL:  $@\n");
    };

    eval{
	verify_password('asdf', 0);
	print("-t5 FAIL, should have errored.");
	1;
    } or do {
	print("-t5 should be an error:  $@\n");
    };

    eval{
	verify_password('ALLUPPERCASE', 0);
	print("-t5 FAIL, should have errored.");
	1;
    } or do {
	print("-t5 should error:  $@\n");
    };

    eval{
	verify_password('alllowercase', 0);
	print("-t5 FAIL, should have errored.");
	1;
    } or do {
	print("-t5 should error:  $@\n");
    };

    eval{
	verify_password('123456789', 0);
	print("-t5 FAIL, should have errored.");
	1;
    } or do {
	print("-t5 should error:  $@\n");
    };

    eval{
	verify_password('1Two3Four5', 0);
	print("-t5 Everything fine\n");
	1;
    } or do {
	print("-t5 FAIL:  $@\n");
    };
    #there are other password things to test but I'll
    #do that at some other time since not all the rules
    #are listed.

}


sub test6(){
    eval{
	change_ldap_password('noexistp3rson', '1Two3Four5', 1);
	print("-t6 FAIL, should have error\n");
	1;
    } or do {
	print("-t6 should error:  $@\n");
    };

    eval{
	change_ldap_password('authtest3', 'bad', 0);
	print("-t6 FAIL, should have error\n");
	1;
    } or do {
	print("-t6 should error:  $@\n");
    };

    eval{
	change_ldap_password('authtest2', '1Two3Four5', 0);
	print("-t6 Everything fine\n");
	1;
    } or do {
	print("-t6 FAIL ERROR:  $@\n");
    };
}

sub test7(){
    eval{
	change_ad_password('n2342xistp3rson', '1Two3Four5', 1);
	print("-t7 FAIL, should have error\n");
	1;
    } or do {
	print("-t7 should error:  $@\n");
    };

    eval{
	change_ad_password('authtest3', 'bad', 0);
	print("-t7 FAIL, should have error\n");
	1;
    } or do {
	print("-t7 should error:  $@\n");
    };

    eval{
	change_ad_password('authtest3', '1Two3Four5', 0);
	print("-t7 Everything fine\n");
	1;
    } or do {
	print("-t7 FAIL ERROR:  $@\n");
    };
}
sub run{
    test1();
    test2();
    test3();
    test4();
    test5();
    test6();
    test7();
    print("FINISHED\n");
}

run();

1
