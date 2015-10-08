require 'serverspec'

set :backend, :exec

def return_true()
  return true
end

def has_directory(in_dir)
  cmd = "bash << eof \n ls -la \n echo -------------- \n ls -lathr \n echo ______________ \n eof"  

  result = `#{cmd}`
  puts ("result = " + result)

  return 'yessir'
end
