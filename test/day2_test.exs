defmodule Day2Test do
	use ExUnit.Case
	doctest Day2P1

	describe "part 1" do
		test "get_cube_grab_values" do
			assert Day2P1.get_cube_grab_values("1 red, 3 green, 2 blue") == [{1, "red"}, {3, "green"}, {2, "blue"}]
		end

		test "get_game_contribution" do
			assert Day2P1.get_game_contribution("Game 1: 1 red, 3 green, 2 blue") == 1
			assert Day2P1.get_game_contribution("Game 2: 1 red, 3 green, 2 blue") == 2
			assert Day2P1.get_game_contribution("Game 3: 1 red, 32 green, 2 blue") == 0
			assert Day2P1.get_game_contribution("Game 4: 12 red, 13 green, 14 blue") == 4
			# This one specifically makes sure that the comparisons are the "or equal to" variety
			assert Day2P1.get_game_contribution("Game 4: 12 red, 13 green, 14 blue; 1 red, 1 green, 1 blue") == 4
		end

		test "solve" do
			assert Day2P1.solve("Game 1: 1 red, 5 green, 3 blue\nGame 2: 3 red, 2 green, 4 blue") == 3
		end
	end
end
