package day1

import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:strings"

main :: proc() {
	data, err := os2.read_entire_file("day1/input.txt", context.allocator)
	if (err != os2.ERROR_NONE) {
		fmt.eprintln("Could not read file:", err)
		os2.exit(1)
	}

	rotations := strings.split_lines(transmute(string)data)
	fmt.println("The password (part1) is:", part1(rotations))
	fmt.println("The password (part2) is:", part2(rotations))
}

part1 :: proc(rotations: []string) -> int {
	dial := 50
	password := 0

	for rotation in rotations {
		dir := rotation[0] == 'R' ? 1 : -1

		disp, ok := strconv.parse_int(rotation[1:], base = 10)
		if !ok {
			fmt.eprintln("Malformed input:", rotation[1:])
			os2.exit(1)
		}

		dial = (dial + dir * disp) %% 100

		if dial == 0 {
			password += 1
		}
	}

	return password
}

part2 :: proc(rotations: []string) -> int {
	dial := 50
	password := 0

	for rotation in rotations {
		dir := rotation[0] == 'R' ? 1 : -1

		disp, ok := strconv.parse_int(rotation[1:], base = 10)
		if !ok {
			fmt.eprintln("Malformed input:", rotation[1:])
			os2.exit(1)
		}

		to_zero := dir == 1 ? (100 - dial) % 100 : dial % 100

		initial_hit := to_zero == 0 ? 100 : to_zero
		if (disp >= initial_hit) {
			password += 1 + (disp - initial_hit) / 100
		}

		dial = (dial + dir * disp) %% 100
	}

	return password
}
