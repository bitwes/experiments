require 'time'

d_string = 'Tue, 10 Mar 2015 21:21:16 GMT'
puts(d_string)
lmd = Time.strptime(d_string, '%a, %e %b %Y %H:%M:%S %Z')      
puts(lmd)