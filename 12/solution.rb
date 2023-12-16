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
   
   #solutions *= sub_solve(input, arr).reject(&:empty?).size
   #puts solutions
   #4.times do 
   # s= sub_solve('?'+input, arr).reject(&:empty?).size
   # puts s
   # solutions *= s
   #end
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

  def solve3(input, arr, solutions = 0)
    puts "solving #{input} #{arr} #{solutions}"
    if (input.size == 0 || arr.empty?)
        puts "empty inputs we're done! #{solutions} solutions found. "
        return solutions
    end
    if (input[0] == '.')
        return solve3(input[1..-1], arr, solutions)
    end
    
    i = 0
    while(i < input.size && input[i] != '.' && arr.size > 0)
      #  puts "inner while input= #{input}, i = #{i}, arr: #{arr}"   
        if (input[i+1] != '#' && i+1 == arr[0])
            newinput = input[i+1..-1]
            if (newinput.delete('.').size + arr.size >= arr.sum)
                puts "recurse (found a solution with more to go) with input #{input[i+1..-1]} #{arr}"
                return solve3(input[i+1..-1], arr, solutions)
            end
            puts "recurse (found a solution) with input #{input[i+1..-1]} #{arr[1..-1]}"
            return solve3(input[i+1..-1], arr[1..-1], solutions+1)
        else
            i += 1
        end
        
    end
    puts "done with wiile loop #{i}"
    return solve3(input[1..-1], arr, solutions)
    
    return solutions
    puts ">>>>>>>>>>>>>>what now #{input}, #{arr}, #{solutions}"
  end
 
  # https://github.com/iggyzuk/advent-of-code/blob/master/2023/day-12-2023/src/bin/part1.rs#L110
def solve4 (input, arr, cache = {}, i = 0)

   # puts "#{input} #{arr} i=#{i}"
    #return 0 if (i > input.size)
    if arr.empty?
       # puts "Array is empty, gonna return sometihng"
        return 0 if i < input.size && input[i..-1].count('#') > 0
       # puts "ONE RESULT!!!"
        return 1
    end

    return 0 if i >= input.size

    while i < input.size do
        if input[i] == "#" || input[i] == "?"
          break
        end
        i += 1
    end

    #return 0 if (i >= input.size)
    
   #puts "index of next broken or unknown is #{i}"

    key = [i, groups.size]
    return cache[key] if cache.key?(key)
    #puts "key #{key}"

    result = 0
   #sleep(1)
    gend = i + arr[0]

    puts "can #{arr[0]} fit in #{input[i..-1]} nicely?  well, any .'s #{input[i..i+arr[0]-1]}, no? then is this a #? #{input[i+arr[0]]} "
    ##if (input[i..i+arr[0]-1].index('.').nil? && input[i+arr[0]] != '#')
    ##    puts "Yes- found group of #{arr[0]} #'s that fits nicely in #{input[i..-1]}"
    ##   # puts "recursing #{input}, #{arr.drop(1)} i=#{i+arr[0]+1}"
    ##    result += solve4(input, arr.drop(1), cache, i+arr[0]+1)
    ##end
    gend = i + arr[0]
    if canfit(input, i, gend)
        result += solve4(input, arr.drop(1), cache, gend+1)
    end

    if input[i] == '?'
       # puts "solve it is the unknown!"
        result += solve4(input, arr, cache, i+1)
    end

   # puts "njow what #{input} #{result}\n\n"
    cache[key] = result
    return result
end

def canfit(springs, start, gend)
    return false if gend >= springs.size
    return false if !springs[start..gend].index(".").nil?
    return false if gend+1 < springs.size && springs[gend+1] == "#"
    return true    
end

class Entry
    attr_accessor :raw, :raw2, :groups, :groups2, :arrangements, :arrangements2
    
    def initialize(raw, groups)
      @raw = raw
      @groups = groups
      @arrangements = solve(raw, groups)
      @arrangements2 = solve4(raw, groups)
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
puts "Part 2: #{inputs.map { |i| i.arrangements2}.reduce(0, :+)}"
