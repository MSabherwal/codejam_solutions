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

input = File.open(clo[:input],'r')

output = File.open(clo[:output], 'w')

total_cases = input.readline.to_i

(1..total_cases).each do |case_num|
	val = input.readline.split(" ").reverse.reduce('') do |memo,obj| 
		memo = memo+" "+obj 
	end
	val = val[1..-1]
	output.write("Case \##{case_num}: #{val}\n")
end

input.close()
output.close()