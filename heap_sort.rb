# if I just use array as the data structure, the code would be a lot shorter :s


# binary heap for using heap sort
class BinaryHeap
	
	# auxillary class, containing meta data of nodes in the same level
	class Level
		# @attr [Node] first_node refering to first node in the level. used in inserting new nodes to the next level
		attr_accessor :first_node
		# @attr [Node] last_node refering to last node in the level. used in deleting a new in the level
		attr_accessor :last_node
		
		# @attr [Integer] depth the depth of this level (0 for root, 1, 2 and so on . . .). just for debugging purpose
		attr_accessor :depth
	end
	
	# each node in the binary heap
	class Node
		# @attr [Numeric] the value of this node
		attr_accessor :value
		
		# @attr [Node] parent the parent node
		attr_accessor :parent
		
		# @attr [Node] left_child the left child node
		# @attr [Node] right_child the right child node
		attr_accessor :left_child, :right_child
		
		# @attr [Level] level the Level of the node
		attr_accessor :level
		
		# @attr [Node] left_sibling the left sibling node
		# @attr [Node] right_sibling the right sibling node
		attr_accessor :left_sibling, :right_sibling
		
		
		# traverse the sub-tree assuming the node as the root. just for debugging purpose
		def traverse
			puts '[%s (%s)]' % [self.value, self.level.depth] 
			if self.left_child
				puts '<'
				self.left_child.traverse
				puts '^'
			end
			if self.right_child
				puts '>'
				self.right_child.traverse
				puts '^'
			end
		end
		
		
		# percolate up in heap sort algorithm
		def percolate_up
			if self.parent
				if self.value < self.parent.value
					temp = self.value
					self.value = self.parent.value
					self.parent.value = temp
					
					self.parent.percolate_up
				end
			end
		end
		
		
		# percolate down in heap sort algorithm
		def percolate_down
			selected_child = nil
			if self.left_child
				selected_child = self.left_child
			end
			if self.right_child
				if self.right_child.value < selected_child.value
					selected_child = self.right_child
				end
			end
			
			if selected_child
				if selected_child.value < self.value
					temp = self.value
					self.value = selected_child.value
					selected_child.value = temp
					
					selected_child.percolate_down
				end
			end
		end
	end
	
	
	# @attr [Node] root_node root node of the binary heap
	attr_accessor :root_node
	
	# @attr [Node] last_node the current last node of the binary heap
	attr_accessor :last_node
	
	
	# insert a value into binary heap
	# @param [Number] value the value to insert
	def insert value
		node  = Node.new
		node.value = value
		
		if self.root_node.nil?
			# first node in the tree
			self.root_node = node
			
			level = Level.new
			level.depth = 0
			level.first_node = node
			level.last_node = node
			node.level = level
		elsif self.last_node.parent.nil?
			# second node in the tree
			self.last_node.left_child = node
			node.parent = self.last_node
			
			level = Level.new
			level.depth = node.parent.level.depth + 1
			level.first_node = node
			node.level = level
		elsif self.last_node.parent.right_child.nil?
			# insert as a right child of current parent
			parent = self.last_node.parent
			parent.right_child = node
			node.parent = parent
			
			node.left_sibling = self.last_node
			self.last_node.right_sibling = node
			
			node.level = self.last_node.level
		elsif self.last_node.parent.right_sibling
			# insert as a left child of the next parent at the same level
			parent = self.last_node.parent.right_sibling
			parent.left_child = node
			node.parent = parent
			
			node.left_sibling = self.last_node
			self.last_node.right_sibling = node
			
			node.level = self.last_node.level
		else
			# grow as the first node of the next level
			self.last_node.level.last_node = self.last_node
			
			parent = self.last_node.level.first_node
			parent.left_child = node
			node.parent = parent
			
			
			level = Level.new
			level.depth = parent.level.depth + 1
			level.first_node = node
			node.level = level
		end
		
		self.last_node = node
		self.last_node.percolate_up
	end
	
	# look at the top value and remove it from the binary heap
	# @return [Number] the top value of the binary heap
	def pop_top
		value = self.peek_top
		self.delete_top
		return value
	end
	
	
	# peak at the top value of binary heap without making any change to the binary heap
	# @return [Numeric] the value of the top of the binary heap
	def peek_top
		self.root_node ? self.root_node.value : nil
	end
	
	# remove the top node from the binary heap. usually used in #pop_top
	def delete_top
		if self.root_node
			if self.root_node == self.last_node
				# only one node in the tree
				self.root_node = nil
				self.last_node = nil
			else
				self.root_node.value = self.last_node.value
				self.delete_last_node
				self.root_node.percolate_down
			end
		end
	end
	
	
	# delete the last node of the binary heap. usually used in #delete_top and #delete_last_node method
	# @note : "self.last_node.parent" is not nil for sure
	def delete_last_node
		if self.last_node == self.last_node.parent.left_child
			self.last_node.parent.left_child = nil
		end
		if self.last_node == self.last_node.parent.right_child
			self.last_node.parent.right_child = nil
		end
		
		if self.last_node.left_sibling
			# still stay in the same level
			self.last_node.level.last_node = nil
			self.last_node.level = nil
			
			self.last_node.left_sibling.right_sibling = nil
			self.last_node = self.last_node.left_sibling
		else
			# go up one level
			self.last_node.level.first_node = nil
			self.last_node.level.last_node = nil
			self.last_node.level = nil
			
			self.last_node = self.last_node.parent.level.last_node
		end
	end
	
	
	# @return [true, false] check if the binary heap is empty
	def empty?
		self.root_node.nil?
	end
end

