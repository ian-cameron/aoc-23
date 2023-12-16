FILE_PATH = "input"

def solve (input, arr, cache = {}, i = 0)

    if arr.empty?
        return 0 if i < input.size && input[i..-1].count('#') > 0
        return 1
    end

    return 0 if (i >= input.size)
    i += [input[i..-1].index("#"), input[i..-1].index("?")].compact.min || 0

    key = i, arr.size
    return cache[key] if cache.key?(key)

    result = 0
    gend = i + arr[0]

    if gend <= input.size && input[i...gend].index(".").nil? && input[gend] != "#"
      result += solve(input, arr.drop(1), cache, gend+1)
    end

    if input[i] == '?'
        result += solve(input, arr, cache, i+1)
    end

    cache[key] = result
    return result
end

class Entry
    attr_accessor :raw, :groups, :arrangements, :arrangements2
  
    def initialize(raw, groups)
      @raw = raw
      @groups = groups
      @arrangements = solve(raw, groups)
      @arrangements2 = solve(([raw]*5).join('?'), groups*5)
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

puts "Part 1: #{inputs.map { |i| i.arrangements}.reduce(0, :+)}"
puts "Part 2: #{inputs.map { |i| i.arrangements2}.reduce(0, :+)}"
