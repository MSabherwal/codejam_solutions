require 'optparse'
require 'set'


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

word_len,num_words,num_cases = input.readline.split(" ").map do |x| x.to_i end

words = []

(1..num_words).each do |word_num|
	word = input.readline.strip!
	words << word

end

def word_to_regex(pattern:)
	return Regexp.new(pattern.gsub(/[ \(\) ]/,'(' => '[',')' => ']'))

end


(1..num_cases).each do |case_num|
	line = input.readline.strip!

	reg_ex = word_to_regex(pattern: line)
	
	count = 0
	words.each do |word|
		count +=1 if word =~ reg_ex
	end
	output.write("Case \##{case_num}: #{count}\n")
	
end



input.close()
output.close()