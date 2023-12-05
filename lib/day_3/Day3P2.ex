defmodule SchematicData do
	defstruct lines: [], width: 0, height: 0

	def new(lines) do
		%SchematicData{
			lines: lines,
			width: String.length(List.first(lines)),
			height: Enum.count(lines)
		}
	end

	def coords(schematic_data, index) do
		{rem(index, schematic_data.width), floor(index / schematic_data.width)}
	end

	def get_char_at(schematic_data, x, y) do
		clamped_x = max(0, min(schematic_data.width - 1, x))
		clamped_y = max(0, min(schematic_data.height - 1, y))

		Enum.at(schematic_data.lines, clamped_y) |> String.at(clamped_x)
	end

	def get_line_at(schematic_data, y) do
		Enum.at(schematic_data.lines, y)
	end
end

defmodule DigitLinker do
	@moduledoc """
	Links n amounts of digit coordinates into a single part number. Used for scanning gears and requiring just one tap for each neighbor cell to be a digit.
	"""

	defstruct numbers: []

	def new() do
		%DigitLinker{
			numbers: []
		}
	end

	def add_number(digit_linker, number, x, y) do
		%DigitLinker{
			numbers: [{number, x, y} | digit_linker.numbers]
		}
	end

	def get_associated_number(digit_linker, x, y) do
		Enum.filter(digit_linker.numbers, fn {number, x2, y2} ->
			# Split number into its digits and check if any of them are adjacent to the current position
			String.split(Integer.to_string(number), "") |>
				Enum.reject(&(&1 == "")) |>
				Enum.with_index |>
				Enum.map(fn {_, index} ->
					digit_x = x2 + rem(index, 3)
					digit_y = y2
					digit_x == x && digit_y == y
				end) |>
				Enum.any?
		end) |> IO.inspect |> List.first # We do provide x and y for filtering out repeats, though the caller does this
	end
end

defmodule GearScanner do
	@moduledoc """
	Given a schematic, scans for gears and returns a list of plausible gears and their associated part numbers.
	"""

	@gear_regex ~r/\*/

	defstruct gears: []

	def new() do
		%GearScanner{
			gears: []
		}
	end

	def add_gear(gear_scanner, x, y, numbers) do
		%GearScanner{
			gears: [{x, y, numbers} | gear_scanner.gears]
		}
	end

	def scan_for_gears(gear_scanner, digit_linker, schematic_data) do
		Enum.reduce(0..(schematic_data.height - 1), gear_scanner, fn y, gear_scanner ->
			# Use regex to scan for gears
			Regex.scan(@gear_regex, SchematicData.get_line_at(schematic_data, y), return: :index) |>
				List.flatten |>
				# For each spotted gear, add it to the list of gears
				Enum.reduce(gear_scanner, fn {index, _}, gear_scanner ->
					# Scan 3x3 for part numbers and record them
					numbers = Enum.reduce(-1..1, [], fn y_offset, numbers ->
						Enum.reduce(-1..1, numbers, fn x_offset, numbers ->
							IO.inspect({index + x_offset, y + y_offset})
							number_info = DigitLinker.get_associated_number(digit_linker, index + x_offset, y + y_offset)
							if number_info != nil do
								{part_number, real_x, real_y} = number_info
								[{real_x, real_y, part_number} | numbers]
							else
								numbers
							end
						end)
					end) |>
					Enum.uniq_by(fn {x, y, _} -> {x, y} end) |>
					Enum.map(fn {_x, _y, part_number} -> part_number end) # Now we just want the part numbers

					add_gear(gear_scanner, index, y, numbers)
				end)
		end)
	end
end

defmodule Day3P2 do
	@moduledoc """
	Solution for Day 3, Part 1 of Advent of Code 2023
	"""

	@doc """
	Input: puzzle input, delimited by newlines
	Output: sum of all valid part numbers
	"""

	@part_number_regex ~r/\d+/

	def make_schematic(schematic_text) do
		SchematicData.new(String.split(schematic_text, "\n") |> Enum.map(&String.trim/1) |> Enum.reject(&(&1 == "")))
	end

	def create_digit_linker(schematic_data) do
		# Scan for part numbers
		IO.inspect(schematic_data)
		Enum.reduce(0..(schematic_data.height - 1), DigitLinker.new(), fn y, digit_linker ->
			Regex.scan(@part_number_regex, SchematicData.get_line_at(schematic_data, y), return: :index) |>
				List.flatten |>
				Enum.reduce(digit_linker, fn {index, size}, digit_linker ->
					part_number = String.slice(SchematicData.get_line_at(schematic_data, y), index, size) |> String.trim |> String.to_integer
					DigitLinker.add_number(digit_linker, part_number, index, y)
				end)
		end)
	end

	def solve(schematic_text) do
		schematic_data = make_schematic(schematic_text)
		digit_linker = create_digit_linker(schematic_data)
		gear_scanner = GearScanner.new() |>
			GearScanner.scan_for_gears(digit_linker, schematic_data) |> IO.inspect(charlists: true)

		gear_scanner.gears |>
			Enum.filter(fn {_x, _y, numbers} ->
				# Check if the gear is valid, meaning numbers is not empty but the amount is less than 3
				numbers != [] && Enum.count(numbers) == 2
			end) |>
			Enum.map(fn {_x, _y, numbers} ->
				List.first(numbers) * List.last(numbers)
			end) |>
			Enum.sum
	end
end
