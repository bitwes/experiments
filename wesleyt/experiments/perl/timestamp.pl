print time() . "\n";

@time = split(/ /, localtime());
print $time[1] . "-" . $time[2] . "-" . $time[4] . "\n";

print localtime() . "\n";
