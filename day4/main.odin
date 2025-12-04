package day4

import "core:fmt"
import "core:os/os2"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
	data, err := os2.read_entire_file("day4/input.txt", context.allocator)
	if (err != os2.ERROR_NONE) {
		fmt.eprintln("Could not read file:", err)
		os2.exit(1)
	}

	board_width := strings.index(transmute(string)data, "\n") + 1
	fmt.println("The password (part1) is:", part1(data, board_width))
	fmt.println("The password (part2) is:", part2(data, board_width))
}

adjacent_count :: proc(data: []byte, board_width: int, pos: int) -> int {
	movements := [8]int {
		-board_width - 1,
		-board_width,
		-board_width + 1,
		-1,
		+1,
		board_width - 1,
		board_width,
		board_width + 1,
	}

	count := 0
	for mov in movements {
		adjacent_pos := pos + mov
		if adjacent_pos < 0 || adjacent_pos >= len(data) do continue

		if data[adjacent_pos] == '@' do count += 1
	}

	return count
}

part1 :: proc(data: []byte, board_width: int) -> int {
	password := 0

	for char, i in data {
		// This also takes care of new lines
		if char == '@' && adjacent_count(data, board_width, i) < 4 {
			password += 1
		}
	}

	return password
}

part2 :: proc(data: []byte, board_width: int) -> int {
	password := 0

	curr_board: []byte = slice.clone(data)
	next_board: []byte = slice.clone(data)
	for {
		removed := 0
		for char, i in curr_board {
			// We must copy to the next state, else we loop for ever
			next_board[i] = char
			if char == '@' && adjacent_count(curr_board, board_width, i) < 4 {
				next_board[i] = 'x'
				removed += 1
			}
		}
		//fmt.println("removed:", removed)
		password += removed
		curr_board, next_board = next_board, curr_board
		if removed == 0 do break
	}

	return password
}
