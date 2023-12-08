defmodule Day4P2 do
	@moduledoc """
	Solution for Day 4, Part 2 of Advent of Code 2023.
	"""

	@card_regex ~r/Card\s+\d+:\s+/
	@card_id_regex ~r/Card\s+(\d+)/

	@doc """
	## Example

		iex> Day4P2.get_numbers_from_card("Card 1: 32 33 11 3 82 | 11 22 33 44 55")
		%{card_id: 1, winning_numbers: [32, 33, 11, 3, 82], active_numbers: [11, 22, 33, 44, 55], winning_active_numbers: [11, 33]}
	"""
	def get_numbers_from_card(card) do
		{_, card_id_length} = Regex.run(@card_regex, card, return: :index) |>
			List.first

		card_id = Regex.run(@card_id_regex, card) |>
			List.last |>
			String.to_integer

		card_numbers = String.slice(card, card_id_length, String.length(card)) |>
			String.split("|") |>
			Enum.map(&String.trim/1)

		winning_numbers = List.first card_numbers
		active_numbers = List.last card_numbers

		[transformed_winning_numbers, transformed_active_numbers] = [winning_numbers, active_numbers] |>
			Enum.map(fn number_string ->
				number_string |>
					String.split(" ") |>
					Enum.map(&String.trim/1) |>
					Enum.filter(&(&1 != "")) |>
					Enum.map(&String.to_integer/1)
			end)

		winning_active_numbers = transformed_active_numbers |>
			Enum.reject(&(!Enum.member?(transformed_winning_numbers, &1)))

		%{
			card_id: card_id,
			winning_numbers: transformed_winning_numbers,
			active_numbers: transformed_active_numbers,
			winning_active_numbers: winning_active_numbers
		}
	end

	@doc """
	## Example

		iex> Day4P2.build_card_list("Card 1: 12 13 | 14 15\\nCard 2: 33 23 | 34 24")
		[%{card_id: 1, winning_numbers: [12, 13], active_numbers: [14, 15], winning_active_numbers: []}, %{card_id: 2, winning_numbers: [33, 23], active_numbers: [34, 24], winning_active_numbers: []}]
	"""
	def build_card_list(input) do
		# while the main purpose is to ensure cards are sorted by their ID, the game input is already sorted so we skip it here
		input |>
			String.split("\n") |>
			Enum.reject(&(&1 == "")) |>
			Enum.map(&get_numbers_from_card/1)
	end

	def count_amount_of_clones(card, card_list, current_amount) do
		# How it works:
		# 1. From the given card, find out the amount of clones that can be made
		# 2. For each clone, find out the amount of clones that can be made, using recursion
		# 3. Sum the total amount of clones

		matches = Enum.count card.winning_active_numbers
		if matches == 0 do
			current_amount
		else
			new_amount = current_amount
			start_id = card.card_id + 1
			clone_index_range = start_id..(start_id + matches - 1)
			clone_cards = Enum.filter(card_list, fn card ->
				Enum.member?(clone_index_range, card.card_id)
			end)

			clone_amounts = clone_cards |>
				Enum.map(fn card ->
					count_amount_of_clones(card, card_list, new_amount)
				end) |>
				Enum.sum

			new_amount + clone_amounts
		end
	end

	@doc """
	## Example

		iex> card_list = Day4P2.build_card_list("Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53\\nCard 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19\\nCard 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1\\nCard 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83\\nCard 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36\\nCard 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11")
		iex> Day4P2.calculate_total_cards(card_list)
		30
	"""
	def calculate_total_cards(card_list) do
		# How it works:
		# 1. Enumerate the cards
		# 2. For each card, find out the amount of winning numbers, and use that to make a copy of card ID through card ID + winning number count
		# 3. Make copies of the said copies until the copies reach a card that has no winning numbers OR the next card is out of bounds
		# 4. Sum the total amount of cards

		card_list |>
			Enum.map(fn card ->
				result = count_amount_of_clones(card, card_list, -1)
				IO.puts("Finished card #{card.card_id}")
				result
			end) |>
			Enum.sum |> Kernel.-
	end

	def solve(input) do
		input |>
			build_card_list() |>
			calculate_total_cards()
	end
end
