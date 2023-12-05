defmodule Day3Test do
	use ExUnit.Case
	describe "part 1" do
		test "part_numbers" do
			# In this one, all except 1 are part numbers
			schematic1 = """
			........223..
			..212...*....
			.....#....12.
			....112......
			"""

			assert Day3P1.part_numbers(Day3P1.make_schematic(schematic1)) == [223, 212, 112]


			schematic2 = """
			.*.
			111
			"""
			assert Day3P1.part_numbers(Day3P1.make_schematic(schematic2)) == [111]
		end

		test "solve_for_sum" do
			schematic1 = """
			........223..
			..212...*....
			.....#....12.
			....112......
			"""

			assert Day3P1.solve_for_sum(Day3P1.make_schematic(schematic1)) == 547

			schematic2 = """
			.*.
			111
			"""

			assert Day3P1.solve_for_sum(Day3P1.make_schematic(schematic2)) == 111
		end
	end

	describe "part 2" do
		# Part 2 is so crazy different that its really not gonna match part 1, so beware

		test "solve" do
			schematic1 = """
			.....#...@..
			..51*.......
			.....12.....
			"""

			assert Day3P2.solve(schematic1) == 612 # 51 * 12, and its the only one gear

			schematic2 = """
			.............
			.....2*......
			.......2.10*.
			...........5.
			"""

			assert Day3P2.solve(schematic2) == 54 # 2 * 2 + 5 * 10 = 54

			# Puzzle example

			schematic3 = """
			467..114..
			...*......
			..35..633.
			......#...
			617*......
			.....+.58.
			..592.....
			......755.
			...$.*....
			.664.598..
			"""

			assert Day3P2.solve(schematic3) == 467835
		end
	end
end
