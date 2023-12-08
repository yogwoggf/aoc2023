defmodule Mix.Tasks.Solve do
	@moduledoc """
	Solves a puzzle given the day number and part and input
	"""

	@puzzle_map %{
		"1P1" => Day1P1,
		"1P2" => Day1P2,
		"2P1" => Day2P1,
		"2P2" => Day2P2,
		"3P1" => Day3P1,
		"3P2" => Day3P2,
		"4P1" => Day4P1,
		"4P2" => Day4P2,
	}

	use Mix.Task

	@impl Mix.Task
	def run([id, input]) do
		puzzle_input = File.read! input
		IO.puts @puzzle_map[id].solve(puzzle_input)
	end
end
