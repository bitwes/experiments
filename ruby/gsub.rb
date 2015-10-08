

=begin
def static_examples()
  puts 'hello_world'.gsub('_', ' ')
  puts '"hello"world"'.gsub('"', ' ')
end

static_examples
=end

def to_hash(thing)
  puts "tohash #{thing}"
  to_hsh(thing)
end


def to_hsh(thing)
  to_return = {}

  thing.split(' ').each do | item |
    schmiggles = item.split('=')
    if(schmiggles.size > 1)
      to_return[schmiggles[0]] = schmiggles[1]#.gsub('d', 'p')
    else
      puts 'too few'
    end
  end

  return to_return
end


puts to_hsh('asdf=>wasd qwerty=>die')

#puts to_hash('asdf=>wasd qwerty=>die')
