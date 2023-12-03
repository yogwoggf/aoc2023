defmodule Day2P2 do
	@moduledoc """
	Solution for Day 2, Part 2 of Advent of Code 2023
	"""

	@doc """
	Input: puzzle input, delimited by newlines
	Output: sum of all valid game ids
	"""

	@game_id_regex ~r/Game (\d+):\s+/
	@cube_record_regex ~r/(\d+) (\w+)/ # e.g. 1 red, 2 green, 3 blue. Numbers are capture groups.

	def get_cube_grab_values(records_text) do
		Regex.scan(@cube_record_regex, records_text)
			|> Enum.map(fn [_, count, color] ->
				{String.to_integer(count), color}
			end)
	end

	def get_game_contribution(game_record_text) do
		[{_, gameid_length} | _] = Regex.run(@game_id_regex, game_record_text, return: :index)
		cube_records = game_record_text
			|> String.slice(gameid_length, String.length(game_record_text) - gameid_length)
			|> String.split(";")
			|> Enum.map(&String.trim/1)
			|> Enum.reject(&(&1 == ""))
			|> Enum.map(&get_cube_grab_values/1)
			|> List.flatten

		# Now we just find the max of each color
		red_cubes = Enum.max(Enum.map(cube_records, fn {count, color} ->
			if color == "red" do
				count
			else
				0
			end
		end))

		green_cubes = Enum.max(Enum.map(cube_records, fn {count, color} ->
			if color == "green" do
				count
			else
				0
			end
		end))

		blue_cubes = Enum.max(Enum.map(cube_records, fn {count, color} ->
			if color == "blue" do
				count
			else
				0
			end
		end))

		red_cubes * green_cubes * blue_cubes
	end

	def solve(game_records_text) do
		game_records_text
			|> String.split("\n")
			|> Enum.reject(&(&1 == ""))
			|> Enum.map(&get_game_contribution/1)
			|> Enum.sum
	end
end
