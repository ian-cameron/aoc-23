FILE_PATH = "input"

  def solve(input, arr, idx = 0, aidx = 0, res = "", results = [])
    #puts "Solving #{input}:, #{arr.join(',')} with #{res}, (#{results.size}) idx: #{idx}, aidx: #{aidx}"

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

class Entry
    attr_accessor :raw, :raw2, :groups, :groups2, :arrangements
    
    def initialize(raw, groups)
      @raw = raw
      @groups = groups
      @arrangements = solve(raw, groups)
    end

    def raw2
        r = raw
        5.times do
            r = r+raw
        end
        r
    end

    def groups2
        g = groups
        5.times do 
            g += groups
        end
        g
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


puts "Part 1: #{inputs.map { |i| i.arrangements.size}.reduce(0, :+)}"