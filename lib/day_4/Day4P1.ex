defmodule Day4P1 do
	@moduledoc """
	Solution for Day 4, Part 1 of Advent of Code 2023.
	"""

	@doc """
	Returns a map with :active_numbers representing the numbers that the card has. The map also contains the :winning_numbers which are the numbers that the card
	needs to win the game.
	"""

	@card_regex ~r/Card\s+\d+:\s+/

	def get_numbers_from_card(card) do
		{_, card_id_length} = Regex.run(@card_regex, card, return: :index) |>
			List.first

		card_numbers = String.slice(card, card_id_length, String.length(card)) |>
			String.split("|") |>
			Enum.map(&String.trim/1)

		winning_numbers = List.first card_numbers
		active_numbers = List.last card_numbers

		IO.inspect winning_numbers
		IO.inspect active_numbers
		[transformed_winning_numbers, transformed_active_numbers] = [winning_numbers, active_numbers] |>
			Enum.map(fn number_string ->
				number_string |>
					String.split(" ") |>
					Enum.map(&String.trim/1) |>
					Enum.filter(&(&1 != "")) |>
					Enum.map(&String.to_integer/1)
			end)

		%{
			winning_numbers: transformed_winning_numbers,
			active_numbers: transformed_active_numbers
		}
	end

	def calculate_card_points(card) do
		%{winning_numbers: winning_numbers, active_numbers: active_numbers} = get_numbers_from_card(card)

		active_winning_numbers = active_numbers |>
			Enum.reject(&(!Enum.member?(winning_numbers, &1))) |>
			Enum.with_index

		matches = Enum.count active_winning_numbers
		case matches do
			0 -> 0
			count -> 2 ** (count - 1)
		end
	end

	def solve(input) do
		input |>
			String.split("\n") |>
			Enum.reject(&(&1 == "")) |>
			Enum.map(&calculate_card_points/1) |>
			Enum.sum
	end
end
