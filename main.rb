# ruby 1.9
require_relative 'heap_sort'


# -- Generate input

input = []
1000.times do
	input << (rand * 100000).to_i
end

# -- Insert into the binary heap

h = BinaryHeap.new
for value in input
	h.insert(value)
end

# -- Print out

while not h.empty?
	puts h.pop_top
end