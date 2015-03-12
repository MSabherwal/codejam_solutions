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


def create_symbol_map(line)
	map = {}
	counter = 0
	line.each_char do |sym|
		next if map[sym] != nil
		case counter
		when 0
			map[sym] = 1
			
		when 1
			map[sym] = 0
			
		else
			map[sym] = counter
			
		end
		counter +=1
	end
	
	return map

end


def calculate_value(map,line)
	# what base the number should be
	base = map.keys.length
	base = 2 if base < 2
	
	
	# trans_int = translate_string(map,line,base)
	value = 0
	pow = line.length-1
	line.each_char do |sym|
		value += (map[sym] *(base**pow))
		
		pow -=1
	end
	return value

end

input = File.open(clo[:input],'r')

total_cases = input.readline.to_i

case_num = 1

output = File.open(clo[:output],'w')

input.readlines[0..total_cases-1].each do |line|
	line = line.strip!
	
	map = create_symbol_map(line)

	val = calculate_value(map,line)
	output.write("Case \##{case_num}: #{val}\n")
	case_num +=1
end

input.close()
output.close()

