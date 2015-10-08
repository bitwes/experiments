n1 = Time.now.usec

# Version 1: use string interpolation syntax.
90000.times do
    cat = "Felix"
    size = 100
    result = "Name: #{cat}, size: #{size}"
end

n2 = Time.now.usec

# Version 2: use string concatenation.
90000.times do
    cat = "Felix"
    size = 100
    result = "Name: " + cat + ", size: " + String(size)
end

n3 = Time.now.usec

# Total milliseconds.
puts ((n2 - n1) / 1000)
puts ((n3 - n2) / 1000)