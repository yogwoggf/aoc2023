defmodule EngineSchematic do
	@symbol_regex ~r/[^\.\d\s]/
	@digit_regex ~r/\d+/

	defstruct lines: [], width: 0, height: 0

	def new(lines) do
		%EngineSchematic{
			lines: lines,
			width: String.length(List.first(lines)),
			height: Enum.count(lines)
		}
	end

	def coords(engine_schematic, index) do
		{rem(index, engine_schematic.width), floor(index / engine_schematic.width)}
	end

	def get_char_at(engine_schematic, x, y) do
		clamped_x = max(0, min(engine_schematic.width - 1, x))
		clamped_y = max(0, min(engine_schematic.height - 1, y))

		Enum.at(engine_schematic.lines, clamped_y) |> String.at(clamped_x)
	end

	def check_for_adjacent_symbols(engine_schematic, x, y) do
		# Basically we just scan 3x3 around the current position and if there's a symbol we terminate and return true

		coord_range = [-1, 0, 1]
		Enum.reduce(coord_range, false, fn x_offset, acc ->
			Enum.reduce(coord_range, acc, fn y_offset, acc ->
				if acc do
					acc
				else
					EngineSchematic.get_char_at(engine_schematic, x + x_offset, y + y_offset) =~ @symbol_regex
				end
			end)
		end)
	end

	@doc """
	Scans the engine schematic for part numbers and returns a list of them. Given a line number (y), it returns it in the following format:

	[
		{"part_number", {x, y}},
		...
	]
	"""
	def scan_for_part_numbers(engine_schematic, y) do
		Regex.scan(@digit_regex, Enum.at(engine_schematic.lines, y), return: :index) |>
			List.flatten |>
			Enum.map(fn {index, size} ->
				part_number = Enum.at(engine_schematic.lines, y) |> String.slice(index, size) |> String.trim
				{part_number, EngineSchematic.coords(engine_schematic, index + (y * engine_schematic.width))}
			end)
	end

	def check_if_part_number(engine_schematic, part_number_tuple) do
		# We need to check all digits around the current position to see if it's a part number
		{part_number, {x, y}} = part_number_tuple

		String.split(part_number, "") |>
			Enum.reject(&(&1 == "")) |>
			Enum.with_index |>
			Enum.any?(fn {_, index} ->
				EngineSchematic.check_for_adjacent_symbols(engine_schematic, x + index, y)
			end)
	end
end

defmodule Day3P1 do
	@moduledoc """
	Solution for Day 3, Part 1 of Advent of Code 2023
	"""

	@doc """
	Input: puzzle input, delimited by newlines.
	Output: sum of part numbers
	"""

	def make_schematic(input) do
		EngineSchematic.new(String.split(input, "\n") |> Enum.map(&String.trim/1) |> Enum.reject(&(&1 == "")))
	end

	def part_numbers(engine_schematic) do
		Enum.reduce(0..(engine_schematic.height - 1), [], fn y, acc ->
			acc ++ (EngineSchematic.scan_for_part_numbers(engine_schematic, y) |>
				Enum.filter(fn part_number_tuple ->
					EngineSchematic.check_if_part_number(engine_schematic, part_number_tuple)
				end) |>
				Enum.map(fn {part_number, _} ->
					String.to_integer(part_number)
				end))
		end) |>
		List.flatten
	end

	def solve_for_sum(engine_schematic) do
		Enum.sum(part_numbers(engine_schematic))
	end

	def solve(input) do
		input
			|> make_schematic()
			|> solve_for_sum()
	end
end
