defmodule Day1P1 do
	@moduledoc """
	Solution for Day 1, Part 1 of Advent of Code 2023
	"""

	@doc """
	Input: puzzle input
	Output: sum of all calibration numbers in the input file
	"""

	def compute_value(corrupted_value) do
		digits = corrupted_value |>
			String.trim |>
			String.split("") |>
			Enum.flat_map(fn x ->
				case Integer.parse(x) do
					{int, _} -> [int]
					_ -> []
				end
			end)

		List.first(digits) * 10 + List.last(digits)
	end

	def solve(puzzle_input) do
		puzzle_input
			|> String.split("\n")
			|> Enum.reject(&(&1 == ""))
			|> Enum.map(&compute_value/1)
			|> Enum.sum
	end
end
