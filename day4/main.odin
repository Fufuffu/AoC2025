package day4

import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:strings"

main :: proc() {
	data, err := os2.read_entire_file("day4/input.txt", context.allocator)
	if (err != os2.ERROR_NONE) {
		fmt.eprintln("Could not read file:", err)
		os2.exit(1)
	}

	data_str := transmute(string)data
	board_width := strings.index(data_str, "\n") + 1
	fmt.println("The password (part1) is:", part1(data_str, board_width))
	//fmt.println("The password (part2) is:", part1(data_str, board_width))
}

adjacent_count :: proc(data: string, board_width: int, pos: int) -> int {
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

part1 :: proc(data: string, board_width: int) -> int {
    password := 0

    for char, i in data {
        // This also takes care of new lines
        if char == '@' && adjacent_count(data, board_width, i) < 4 {
            password += 1
        }
    }

    return password
}
