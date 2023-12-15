FILE_PATH = "example"

  def solve(input, arr, idx = 0, aidx = 0, res = "", results = [])

    if idx == input.size
      if res.size == input.size && res.split('.').map(&:size).reject(&:zero?) == arr
        results << res
      end
      return results
    end
  
    if input[idx] == '?'
      if aidx < arr.size && (res.empty? || res[-1] == '.' || res.split('.').last.size < arr[aidx])
        solve(input, arr, idx + 1, aidx, res + '#', results)
      end
      solve(input, arr, idx + 1, aidx + (res[-1] == '#' ? 1 : 0), res + '.', results)
    elsif input[idx] == '#'
      solve(input, arr, idx + 1, aidx, res + '#', results)
    elsif input[idx] == '.'
      solve(input, arr, idx + 1, aidx + (res[-1] == '#' ? 1 : 0), res + '.', results)
    end
  
  end

  def solve2(input, arr, idx = 0, aidx = 0, res = "", results = [])
    # puts "Solving #{input}:, #{arr.join(',')} with #{res}, (#{results.size}) idx: #{idx}, aidx: #{aidx}"
   i=0
   solutions = 1
   solutions *= sub_solve(input, arr).reject(&:empty?).size
   4.times do 
    solutions *= sub_solve('?'+input, arr).reject(&:empty?).size
   end
 ####for pre-expanded  puts "going for #{input} #{arr}"
 ####for pre-expanded  input.split('.').reject(&:empty?).each do |piece|
 ####for pre-expanded    subarr = []
 ####for pre-expanded    while(i < arr.size && subarr.sum + subarr.size < piece.size && subarr.sum + arr[i].to_i + subarr.size <=  piece.size)
 ####for pre-expanded      subarr << arr[i]
 ####for pre-expanded      i += 1
 ####for pre-expanded     # puts "looped"
 ####for pre-expanded    end
 ####for pre-expanded    puts "Time to solve #{piece} with #{subarr}"
 ####for pre-expanded    solutions *= sub_solve(piece, subarr).reject(&:empty?).size
 ####for pre-expanded    puts "Result: #{piece} #{subarr} has #{solutions} solutions."
 ####for pre-expanded  end
   puts "#{input}x5 has #{solutions}"
   return solutions
   
   end

  $memo = {}
  def sub_solve(input, arr, idx=0, aidx=0, res="", results = [])
    #puts "#{input} is input #{arr}"
    key = [input, arr]
  #  puts key
  #  
  if $memo.key?(key)
       puts "cache hit!!!!!! OMG! #{key}: #{$memo[key]} "
     end
    return $memo[key] if $memo.key?(key)
   #   puts "cache hit!!!!!! OMG! #{key}"
   # end

    if idx == input.size
      if res.size == input.size && res.split('.').map(&:size).reject(&:zero?) == arr
        results << res
        
        #if (aidx==arr.size && idx == res.size)
        #  $memo[key] = results
        #end
      end
      return results
    end

    # if index is unknown
    if input[idx] == '?'
  #    puts 1
      # continue adding broken spring to end until we meet the group quota
      if aidx < arr.size && (res.empty? || res[-1] == '.' || res.split('.').last.size < arr[aidx])
       #puts res
        sub_solve(input, arr, idx + 1, aidx, res + '#', results)
      #  puts 2
      end
      # move on to next group if the last broken spring was just added
      sub_solve(input, arr, idx + 1, aidx + (res[-1] == '#' ? 1 : 0), res + '.', results)
     # puts 3
    # if its a broken spring move on, keep the group
    elsif input[idx] == '#'
      sub_solve(input, arr, idx + 1, aidx, res + '#', results)
    #  puts 5
    #if its a working spring and the last spring was broken, go to the next group
    elsif input[idx] == '.'
      sub_solve(input, arr, idx + 1, aidx + (res[-1] == '#' ? 1 : 0), res + '.', results)
      #puts 6
    end
 #   puts "We are here idx: #{idx}/#{input.size}, and aidx: #{aidx}/#{arr.size}"
    if (aidx==arr.size && idx == results.size)
      puts "should we log #{key} has #{results.size} total results. idx: #{idx}, aidx: #{aidx}"
      $memo[key] = results
    end
    return results

  end


class Entry
    attr_accessor :raw, :raw2, :groups, :groups2, :arrangements, :arrangements2
    
    def initialize(raw, groups)
      @raw = raw
      @groups = groups
      @arrangements = solve(raw, groups)
      @arrangements2 = solve2(raw, groups)
    end

    def raw2
      ([raw]*5).join('?')
    end

    def groups2
        groups*5
    end
    def regex
        pattern = "^"
        groups.each do |i|
            pattern += '#{'+i.to_s+'}\.+'
        end
        pattern[-1]='?'
        Regexp.new pattern
    end
end

inputs = []
File.open(FILE_PATH, "r") do |file|
  file.each_line do |line|
    parts = line.split(" ")
    raw = parts[0]
    groups = parts[1].split(",").map(&:to_i)
    entry = Entry.new(raw, groups)
  inputs << entry
  end
end

#puts $memo

puts "Part 1: #{inputs.map { |i| i.arrangements.size}.reduce(0, :+)}"
puts "Part 1: #{inputs.map { |i| i.arrangements2}.reduce(0, :+)}"
