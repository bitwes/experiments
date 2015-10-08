def some_method()
  puts "--------------- SOME METHOD CALLED ---------------"
end

def override_an_attribute(new_value)
  puts "was #{node['an_attribute']}"
  node.override['an_attribute'] = new_value
  puts "now #{node['an_attribute']}"
end
