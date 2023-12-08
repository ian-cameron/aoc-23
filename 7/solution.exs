defmodule Solution do
  def process_file do
    file_path = "input"
    map = File.stream!(file_path)
      |> Enum.map(&process_line/1)
      |> Map.new()
    calculate(map)
      |> (&("Part 1: #{&1}")).()
      |> IO.puts()
    map = File.stream!(file_path)
      |> Enum.map(&process_line_jokers/1)
      |> Map.new()
    calculate(map)
      |> (&("Part 2: #{&1}")).()
      |> IO.puts()
  end

  def calculate(lines) do
    Map.new(lines)
    |> Map.to_list()
    |> Enum.sort_by(fn {key, _} -> key end, :asc)
    |> Enum.sort(&sort_hands/2)
    |> Enum.with_index(1)
    |> Map.new(fn {{k,{v,_}}, i} -> {k, v*i} end)
    |> Enum.reduce(0, fn {_, value}, acc -> acc + value end)
  end

  def order_ranks(hand) do
      hand
      |> String.replace("K", "B")
      |> String.replace("Q", "C")
      |> String.replace("J", "D")
      |> String.replace("T", "E")
      |> String.replace("9", "F")
      |> String.replace("8", "G")
      |> String.replace("7", "H")
      |> String.replace("6", "I")
      |> String.replace("5", "J")
      |> String.replace("4", "K")
      |> String.replace("3", "L")
      |> String.replace("2", "M")
  end

  def process_line(line) do
    [hand, score] = String.split(String.trim(line), " ")
    modified_hand = hand
      |> order_ranks()
    char_count = modified_hand
      |> String.graphemes()
      |> Enum.frequencies()
      |> Enum.sort_by(fn {_, count} -> -count end)
      |> Enum.map(fn {_, count} -> count end)
      |> Enum.join()
      |> String.pad_trailing(5,"0")
    {modified_hand, {String.to_integer(score), char_count}}
  end

  def process_line_jokers(line) do
    [hand, score] = String.split(String.trim(line), " ")
    modified_hand = hand
      |> order_ranks()
      |> String.replace("D","Z")
    char_count = modified_hand
      |> String.graphemes()
      |> Enum.frequencies()
      |> (fn map ->
        if !!map["Z"] and map_size(map) > 1 do
          max_key = map  |> Map.delete("Z") |> Enum.max_by(&elem(&1, 1)) |> elem(0)
          Map.update!(map, max_key, &map["Z"] + (&1 || 1)) |> Map.delete("Z")
        else
          map
        end
      end).()
      |> Enum.sort_by(fn {_, count} -> -count end)
      |> Enum.map(fn {_, count} -> count end)
      |> Enum.join()
      |> String.pad_trailing(5,"0")
    {modified_hand, {String.to_integer(score), char_count}}
  end

  def sort_hands({k1, {_,s1}}, {k2, {_,s2}}) do
    if s1 == s2 do
      k1 > k2
    else
      s2 > s1
    end
  end
end

Solution.process_file()
