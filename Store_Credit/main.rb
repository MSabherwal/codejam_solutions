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

def solution(credit,prices)
	prices.each_with_index do |val_1,val_1_index|
		(val_1_index+1..prices.length-1).each do|val_2_index|
			return val_1_index,val_2_index if val_1+prices[val_2_index] == credit
		end
	end
end





input = File.open(clo[:input],'r')

output = File.open(clo[:output],'w')

total_cases = input.readline.to_i

# puts "num_of_cases = #{total_cases}"

(1..total_cases).each do |case_num|
	credit = input.readline.to_i
	num_items = input.readline.to_i
	prices = input.readline.split(" ").map do |x|
		x.to_i
	end
	val_1,val_2 = solution(credit,prices)

	puts "  credit = #{credit}"
	puts "  num_items = #{num_items}"
	puts "  prices = #{prices.inspect}"
	puts "  index of items = #{val_1} #{val_2}"
	output.write("Case \##{case_num}: #{val_1+1} #{val_2+1}\n")
end

input.close()
output.close()