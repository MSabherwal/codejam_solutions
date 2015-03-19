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

def valid_combinations(line:,word_len:,valid_words:)

	char_index = 0
	line_seg = ''
	words = Set.new()
	while char_index < word_len
		
		if line[0] == '('
			letters = []
			line.slice!(0) # get rid of '('
			while line[0] != ')' do
				char = line.slice!(0)
				
				letters << char		
			end
			 
			#if letters is empty, there are no valid letters at that index
			# therefore, there are no matches
			if letters.empty?
				return []
			end
			
			words_cp = Array.new(letters.length) {Set.new(words)}
			# puts "words_cp = #{words_cp}"
			letters.each_index do |letter_index|
				# puts "letter at index #{letter_index} = #{letters[letter_index]}"
				if words_cp[letter_index].empty?
					words_cp[letter_index].add(letters[letter_index])
				else
					words_cp[letter_index].map! do |x|
						x+=letters[letter_index] 
					end
				end
				# puts words_cp.inspect
			end

			#merge all words to one array
			words_cp.each do |x|
				words = words.union(x)
			end
			# puts "words = #{words.inspect}"

			line.slice!(0) # remove the ')'
			
			return words if line.empty?
		else #static characters
			if words.empty?
				words.add(line.slice!(0))
			else
				words.map do |x|
					x+=line[0]
				end
				line.slice!(0)
			end
		end
		char_index +=1
	end
	puts "words = #{words.inspect}"
	return valid_words.intersection(words)
end


input = File.open(clo[:input],'r')

output = File.open(clo[:output], 'w')

word_len,num_words,num_cases = input.readline.split(" ").map do |x| x.to_i end

valid_words = Set.new()


(1..num_words).each do |word_num|
	word = input.readline.strip!
	valid_words.add(word)

end
puts "valid_words = #{valid_words.inspect}"


(1..num_cases).each do |case_num|
	line = input.readline.strip!
	
	valid_comb = valid_combinations(line: line,word_len: word_len,valid_words: valid_words)
	puts "valid_comb = #{valid_comb.inspect}"
	puts "valid_words = #{valid_words.inspect}"
	
end



input.close()
output.close()