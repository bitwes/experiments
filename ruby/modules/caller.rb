$LOAD_PATH << '.'
require 'my_module'

#MyModule.puts_lotion()

puts MyModule::LOTION
MyModule.puts_lotion('basket')
