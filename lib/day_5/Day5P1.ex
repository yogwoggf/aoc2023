# Basically, this problem requires extreme flexibility in the way we handle the input data.

defmodule Mapper do
	defstruct source_range: nil, dest_range: nil, range_length: nil

	def new(source_range, dest_range, range_length) do
		%__MODULE__{source_range: source_range, dest_range: dest_range, range_length: range_length}
	end

	@doc """
		## Examples
			iex> mapper = Mapper.new(50, 70, 3)
			iex> Mapper.map_input_number(mapper, 52)
			72
	"""
	def map_input_number(mapper, input_number) do
		if input_number > mapper.source_range + mapper.range_length || input_number < mapper.source_range do
			nil
		else
			local_number = input_number - mapper.source_range
			# if source range is in 50 to 53, then 52 is localized to 2
			mapper.dest_range + local_number
		end
	end

	@doc """
		## Examples
			iex> mappers = [[%Mapper{dest_range: 1, range_length: 1, source_range: 15}], [%Mapper{dest_range: 15, range_length: 1, source_range: 1}]]
			iex> Mapper.multi_map(mappers, 15)
			15
	"""
	def multi_map(mappers, start_input_number) do
		# The main issue is that a range in 1 mapper group doesn't necessarily mean the same thing in another mapper group.
		# So, we have to very carefully sequentially map the input number through each mapper group.
		# For example, if we have a mapper group that maps 50-53 to 70-73, and another mapper group that maps 70-73 to 90-93, we can't just map 50-53 to 90-93.
		# We have to go through each mapper group sequentially, mapping 50-53 to 70-73, then 70-73 to 90-93.

		final_output = mappers |>
			Enum.reject(&(&1 == [])) |>
			List.foldl(start_input_number, fn mapper_group, input_number ->
				IO.inspect(input_number)
				IO.inspect(mapper_group)
				result = Enum.map(mapper_group, fn mapper -> Mapper.map_input_number(mapper, input_number) end) |> Enum.reject(&(&1 == nil)) |> List.first
				if result == nil do
					# If we couldn't map the input number through the current mapper group, then we return nil
					input_number
				else
					# Otherwise, we return the result of the mapping
					result
				end
			end)

		IO.inspect(final_output, label: "final_output")
		if final_output == nil do
			# If we couldn't map the input number through all the mapper groups, then we return the original input number
			start_input_number
		else
			# Otherwise, we return the final output
			final_output
		end
	end
end

defmodule Day5P1 do
	@moduledoc """
	Solution for Day 5, Part 1 of Advent of Code 2023
	"""

	@seed_header_regex ~r/seeds:\s+/
	@digit_regex ~r/\d+/

	def build_lines_from_input(input), do: String.split(input, "\n") |> Enum.reject(&(&1 == ""))

	@doc """
		## Examples
			iex> lines = Day5P1.build_lines_from_input("seeds: 1 2 32 11")
			iex> Day5P1.get_input_seeds(lines)
			[1, 2, 32, 11]
	"""
	def get_input_seeds(lines) do
		seed_line = List.first(lines)
		{_, length} = Regex.run(@seed_header_regex, seed_line, return: :index) |> List.first

		seed_line |>
			String.slice(length, String.length(seed_line)) |>
			String.trim |>
			String.split(" ") |>
			Enum.map(&String.to_integer/1) |>
			Enum.reject(&(&1 == nil))
	end

	@doc """
		## Examples
			iex> lines = Day5P1.build_lines_from_input("seeds: 1 2 32 11\\nfartmap:\\n1 15 1\\npeemap:\\n15 1000 1")
			iex> Day5P1.create_mappings(lines)
			[[], [%Mapper{dest_range: 1, range_length: 1, source_range: 15}], [], [%Mapper{dest_range: 15, range_length: 1, source_range: 1000}]]
	"""
	def create_mappings(lines) do
		lines |>
			Enum.drop(1) |> # Removes the first line, which is the seed line
			Enum.map(fn line ->
				if Regex.run(@digit_regex, line) == nil do
					{:header, line}
				else
					{:mapping, line}
				end
			end) |>
			Enum.chunk_by(fn {type, _} -> type end) |>
			Enum.map(fn group ->
				# Turn each mapping line in the group into a Mapper struct
				Enum.flat_map(group, fn data ->
					case data do
						{:header, _} -> []
						{:mapping, line} ->
							[dest_range, source_range, range_length] = String.split(line, " ") |> Enum.reject(&(&1 == "")) |> Enum.map(&String.to_integer/1)
							[Mapper.new(source_range, dest_range, range_length)]
					end
				end)
			end)
	end

	@doc """
		## Examples
			iex> Day5P1.solve("seeds: 79 14 55 13
			...> seed-to-soil map:
			...> 50 98 2
			...>52 50 48
			...>soil-to-fertilizer map:
			...>0 15 37
			...>37 52 2
			...>39 0 15
			...>fertilizer-to-water map:
			...>49 53 8
			...>0 11 42
			...>42 0 7
			...>57 7 4
			...>water-to-light map:
			...>88 18 7
			...>18 25 70
			...>light-to-temperature map:
			...>45 77 23
			...>81 45 19
			...>68 64 13
			...>temperature-to-humidity map:
			...>0 69 1
			...>1 0 69
			...>humidity-to-location map:
			...>60 56 37
			...>56 93 4")
			35
	"""
	def solve(input) do
		lines = build_lines_from_input(input)
		seeds = get_input_seeds(lines)
		mappers = create_mappings(lines)

		Enum.map(seeds, fn seed -> Mapper.multi_map(mappers, seed) end) |> Enum.min
	end
end
