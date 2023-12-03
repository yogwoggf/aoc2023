defmodule Day1P2 do
	@moduledoc """
	Solution for Day 1, Part 2 of Advent of Code 2023
	"""

	@doc """
	Input: puzzle input, with either digits or English numbers
	Output: sum of all calibration numbers in the input file
	"""

	# Note that due to the requirements of part 2, I ended up just using a different approach instead of building on part 1.

	@english_number_map %{
		"one" => 1,
		"two" => 2,
		"three" => 3,
		"four" => 4,
		"five" => 5,
		"six" => 6,
		"seven" => 7,
		"eight" => 8,
		"nine" => 9,
	}

	# smirk kiss face
	@english_overlapping_regex ~r/(?=(\d|one|two|three|four|five|six|seven|eight|nine))/
	@any_digit ~r/\d+/

	def numeral_to_digit(numeral) do
		if Regex.match?(@any_digit, numeral) do
			# Regex match means this is not a potentially ill-formed digit so we can just return it
			String.to_integer(numeral)
		else
			@english_number_map[numeral]
		end
	end

	def compute_value(corrupted_value) do
		digits = Regex.scan(@english_overlapping_regex, corrupted_value)
			|> Enum.map(fn [_, capture] ->
				numeral_to_digit(capture)
			end)

		# can't pipe since unary + has higher precedence than arithmetic operators
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
