require 'optparse'


clo = {
	input: nil,
	output: nil
}

OptionParser.new do |opts|
	opts.banner = "Usage: ruby main.rb [options]"
	opts.on('-i', "--input [path/to/input/file]", String,'path to input file') do |v|
		clo[:input] = v
	end
	opts.on('-o', "--output [path/to/output/file]", String,'path to the file to be written to') do |v|
		clo[:output] = v
	end
end.parse!(ARGV)

if clo[:input].nil? or clo[:output].nil?
	raise('require both input and output files')
end



def calculate_scalar(vect_1,vect_2)
	#obtain pos and neg vectors for each
	pos_1,neg_1 = sort_vector(vect_1)
	pos_2,neg_2 = sort_vector(vect_2)


	#multiply lowest neg to highest pos, removing from each
	scalar = 0
	neg_multiply = lambda do |neg,pos,scalar|
		smaller_len  = pos.length > neg.length ? neg.length : pos.length 
		(1..smaller_len).each do |x|
			scalar += neg.shift * pos.pop
		end
		return pos,neg,scalar
	end
	# of them will be completed, though which is not clear...
	pos_2,neg_1,scalar = neg_multiply.call(neg_1,pos_2,scalar)
	pos_1,neg_2,scalar = neg_multiply.call(neg_2,pos_1,scalar)

	#multiply remaining vectors from either pos or neg
	# IF pos_1 ==nil
		# if neg_2 == nil?
			# means both vectors equal and opposite
			# return scalar
		# elsif pos_2 == nil?
			#neg_1 and neg_2 stil have values
			#scalar += neg_1.pop * neg_2.shift
	# ELIF neg_1 == nil?
		# IF pos_2 == nil?
			#means both vectors equal and opposite
			#return scalar
		# if neg_2 == nil?
			# pos_1 and pos_2 still have values
			# multiply at index
		# neg_1[index] * pos_2[index]

		if pos_1.empty?
			if neg_2.empty?
				return scalar
			elsif pos_2.empty?
				(1..neg_1.length).each do |index|
					scalar += neg_1.shift*neg_2.pop
				end
			else
				raise ('pos_2 and neg_2 both empty?')
			end
		elsif neg_1.empty?
			if pos_2.empty?
				return scalar
			elsif neg_2.empty?
				(1..pos_1.length).each do |index|
					scalar += pos_1.shift * pos_2.pop
				end
			else
				raise "somethign crazy happened"
			end
		else
			puts 
			raise ('no idea wth happened, but its an error')
		end

	# pos_2.reverse!
	# pos_1.each_with_index do |val,index|
	# 	scalar += pos_1[index]*pos_2[index]
	# end
	


	return scalar
end

#sorts vector into two array:
	# 1 = all elements > 0
	# 2 = all element <  0
def sort_vector(ary)
	neg,pos = [],[]
	ary.each do |val|
		if val >= 0
			pos << val
		else
			neg << val
		end
	end
	#sorts min -> max
	pos.sort!
	neg.sort!
	return pos,neg
end



input = File.open(clo[:input],'r')

output = File.open(clo[:output], 'w')


total_cases = input.readline().to_i

(1..total_cases).each do |case_num|
	array_len = input.readline.to_i
	vect_1 = input.readline.split(" ").map do |x| x.to_i end
	vect_2 = input.readline.split(" ").map do |x| x.to_i end
	puts "vect 1 = #{vect_1}"
	puts "vect 2 = #{vect_2}"
	scalar = calculate_scalar(vect_1,vect_2)
	output.write("Case \##{case_num}: #{scalar}\n")
end


input.close()
output.close()