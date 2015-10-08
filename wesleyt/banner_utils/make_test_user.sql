rem PL/SQL Developer Test Script

set feedback off
set autoprint off

rem Execute PL/SQL Block
declare
    DEFAULT_DEGREE_CODE         constant varchar2(100) := 'BA';
    DEFAULT_PROGRAM             constant varchar2(100) := 'BA-AS';
    DEFAULT_DEPARTMENT          constant varchar2(100) := 'ACCT';
    DEFAULT_LEVEL               constant varchar2(100) := 'G';
    DEFAULT_MAJOR               constant varchar2(100) := 'CSCI';
    DEFAULT_TERM                constant varchar2(100) := xu_common_library.f_get_next_term(xu_common_library.F_Get_Curr_Term_Start_2_Start);

    -- Non-scalar parameters require additional processing 
    io_student_props xu_test_data.t_student_props;
begin
    io_student_props.pidm := null;
    io_student_props.first_name := 'Testerson';
    io_student_props.last_name := 'Tester';
    io_student_props.mi := 'T';
    io_student_props.dob := to_date('05/25/1977', 'mm/dd/yyyy');

    --setup/reset the default student settings before each test.
    io_student_props.pidm := null;
    io_student_props.department := DEFAULT_DEPARTMENT;
    io_student_props.program := DEFAULT_PROGRAM;
    io_student_props.stu_level := DEFAULT_LEVEL;
    io_student_props.degree_code := DEFAULT_DEGREE_CODE;
    io_student_props.majr := DEFAULT_MAJOR;
    io_student_props.term := DEFAULT_TERM;
  
    -- Call the procedure
    xu_test_data.create_test_student(io_student_props => io_student_props);      
    xu_test_data.print_t_student_props(io_student_props);
end;
/
