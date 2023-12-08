defmodule Day4Test do
  	use ExUnit.Case
	doctest Day4P2

	describe "part 1" do
		test "get_numbers_from_card" do
			card = "Card 1: 32 33 11 3 82 | 11 22 33 44 55"

			%{winning_numbers: winning_numbers, active_numbers: active_numbers} = Day4P1.get_numbers_from_card(card)
			assert winning_numbers == [32, 33, 11, 3, 82]
			assert active_numbers == [11, 22, 33, 44, 55]
		end

		test "calculate_card_points" do
			cards_answers = [
				{"Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19", 2},
				{"Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1", 2},
				{"Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83", 1},
				{"Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36", 0}
			]

			for {card, answer} <- cards_answers do
				IO.inspect(card, label: "asserting card value")
				assert Day4P1.calculate_card_points(card) == answer
			end
		end
	end
end
