#!/usr/bin/perl

use strict;
my $_runid = -1;

require "$ENV{XU_HOME}/general/xu_ora.pm";

xu_ora::set_serveroutput_on();
xu_ora::set_print_commands_off();


sub call_function_return_result{
    my ($function_call) = @_;
    my $delim = '*__*';
    my $result = xu_ora::run_sql("exec xu_log.resume_run($_runid);\n" . "exec dbms_output.put_line('$delim' || $function_call || '$delim');");

    return get_text_between($result, $delim);
}

sub my_run_sql{
    my ($to_run) = @_;

    my $result = xu_ora::run_sql("set echo off\n" .
                                 "exec xu_log.resume_run($_runid);\n" . 
                                 "$to_run\n" );
    return $result;
}

sub get_text_between{
    my ($text_to_parse, $front, $back) = @_;
    $back = $front if !$back;
    my $start_loc = index($text_to_parse, $front) + length($front);
    my $end_loc = index($text_to_parse, $back, $start_loc) - $start_loc;

    return substr($text_to_parse, $start_loc, $end_loc);
}

sub start_log_run{
    my ($app_name) = @_;
    $_runid = call_function_return_result("xu_log.start_run('$app_name')");
}

sub main{
    #start_log_run("perl_test");
    print my_run_sql("exec xu_log_from_perl;");
    print my_run_sql("exec xu_log.print('this is a call to all my...');");
    print my_run_sql("exec xu_log_from_perl;");
    #print my_run_sql("exec xu_log.error('OH NO!  ERRORRED!!');");
    print "Error count:  " . call_function_return_result("xu_log.get_error_count") . "\n";
}

main;

