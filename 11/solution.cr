filename = "input"

lines = File.read_lines(filename)
rowcount = lines.size
colcount = lines[0].size
cols = Array.new(colcount, 0)

# determine the size of space and find empty rows and columns to expand
lines.each do |line|
  galaxies = 0
  line.each_char.with_index do |c, i|
    if c == '#'
      galaxies += 1
      cols[i] += 1
    end
  end
  if galaxies == 0
    rowcount = rowcount+1
  end
end
colcount = colcount + cols.count(0)
# Expansion factors for part 2
offset = 999998
roffset = 0
coffset = 0
p2ro = Array.new(rowcount, 0)
p2co = Array.new(colcount, 0)

z = 0
cols.each_with_index do |c, i|
  if c == 0
    p2co[i+z] = coffset
    coffset += offset
    z += 1 
  end
  p2co[i+z] = coffset
end

# create the field of space
space = Array(Array(Char)).new(rowcount){ Array(Char).new(colcount) }
i = 0
lines.each do |line|
  if line.chars.all?{|c| c=='.'}
    # expand empty rows size
    space[i] = Array(Char).new(colcount, '.')
    space[i+1] = Array(Char).new(colcount, '*')
    p2ro[i] = roffset
    roffset += offset
    p2ro[i+1] = roffset
    i=i+2
  else
    line.each_char.with_index do |c, j|
      if cols[j] == 0
        # expand empty columns size
        space[i]<< '.' << '*'
      else
        space[i] << c
      end
    end
    i += 1
  end
  p2ro[i-1] = roffset
end

galaxyPairs = [] of GalaxyPair
recentCol = 0

space.each.with_index do |row, r|
  # puts row.join
  row.each.with_index do |val, c|
    if (val == '#')
      space.each.with_index do |row2, r2|
        next if r2 < r
        row2.each.with_index do |val2, c2|
          next if r2 == r && c2 < recentCol
          if (val2 == '#')
            galaxyPairs << GalaxyPair.new(r, c, r2, c2) unless (r == r2 && c == c2)
          end
        end
      end
    end
    recentCol = c
  end
  recentCol = 0
end

part1 = 0
galaxyPairs.each do |g|
  part1 += + g.distance
end

puts "Part 1: #{part1}"

# Reset and calc part 2
galaxyPairs = [] of GalaxyPair
recentCol = 0

space.each.with_index do |row, r|
  #puts row.join
  row.each.with_index do |val, c|
    if (val == '#')
      space.each.with_index do |row2, r2|
        next if r2 < r
        row2.each.with_index do |val2, c2|
          next if r2 == r && c2 < recentCol
          if (val2 == '#')
            galaxyPairs << GalaxyPair.new(r+p2ro[r], c+p2co[c], r2+p2ro[r2], c2+p2co[c2]) unless (r == r2 && c == c2)
          end
        end
      end
    end
    recentCol = c
  end
  deltaR = 0
  recentCol = 0
end

part2 = 0_i64
galaxyPairs.each do |g|
  part2 += g.distance
end

puts "Part 2: #{part2}"

class GalaxyPair
  @fromR : Int32
  @fromC : Int32
  @toR : Int32
  @toC : Int32
  
  def initialize(@fromR, @fromC, @toR, @toC)
  end 
  
  def distance
    (@fromR-@toR).abs + (@fromC-@toC).abs
  end

  def words
    "From #{@fromR},#{@fromC} to #{@toR},#{@toC} = #{distance}"
  end
end
