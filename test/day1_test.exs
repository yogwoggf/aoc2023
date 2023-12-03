defmodule Day1Test do
	use ExUnit.Case
	doctest Day1P1

	describe "part 1" do
		test "compute_value" do
			assert Day1P1.compute_value("1aff4") == 14
			assert Day1P1.compute_value("3eeafsaf4") == 34
		end
		test "solve" do
			assert Day1P1.solve("afsaf2asf5\nq1da2adsd5") == 40
			assert Day1P1.solve("m3masdm0a\nq1da2adsd5") == 45
			# Input from the puzzle
			assert Day1P1.solve("1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet\n") == 142
		end
	end

	describe "part2" do
		test "compute_value" do
			assert Day1P2.compute_value("1aff4") == 14
			assert Day1P2.compute_value("3weinerone") == 31
			# Input from the puzzle
			#two1nine
			#eightwothree
			#abcone2threexyz
			#xtwone3four
			#4nineeightseven2
			#zoneight234
			#7pqrstsixteen
			assert Day1P2.compute_value("two1nine") == 29
			assert Day1P2.compute_value("eightwothree") == 83
			assert Day1P2.compute_value("abcone2threexyz") == 13
			assert Day1P2.compute_value("xtwone3four") == 24
			assert Day1P2.compute_value("4nineeightseven2") == 42
			assert Day1P2.compute_value("zoneight234") == 14
			assert Day1P2.compute_value("7pqrstsixteen") == 76
		end

		test "solve" do
			# Full combined input from the puzzle
			assert Day1P2.solve("two1nine\neightwothree\nabcone2threexyz\nxtwone3four\n4nineeightseven2\nzoneight234\n7pqrstsixteen\n") == 281
			# Previous test input
			assert Day1P2.solve("1abc2\npqr3stu8vwx\na1b2c3d4e5f\ntreb7uchet\n") == 142
			assert Day1P2.solve("afsaf2asf5\nq1da2adsd5") == 40
			assert Day1P2.solve("faqaugconeeighttwo3\nbone5") == 28
 		end
	end
end
