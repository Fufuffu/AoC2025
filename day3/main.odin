package day3

import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:strings"

main :: proc() {
	data, err := os2.read_entire_file("day3/input.txt", context.allocator)
	if (err != os2.ERROR_NONE) {
		fmt.eprintln("Could not read file:", err)
		os2.exit(1)
	}

	banks := strings.split_lines(transmute(string)data)
	fmt.println("The password (part1) is:", part1(banks))
	fmt.println("The password (part2) is:", part2(banks))
}

part1 :: proc(banks: []string) -> int {
	password := 0

	for bank in banks {
		max_left_value := -1
		max_left_pos := 0

		max_right_value := -1

		for char, i in bank {
			// We cannot use the right most character as the max, otherwise we would not have a "0-9" value
			if i == len(bank) - 1 do continue
			value, ok := strconv.digit_to_int(char)
			assert(ok, "Character was not a digit")

			if value > max_left_value {
				max_left_value = value
				max_left_pos = i
			}
		}

		for char, i in bank[max_left_pos + 1:] {
			value, ok := strconv.digit_to_int(char)
			assert(ok, "Character was not a digit")

			if value > max_right_value {
				max_right_value = value
			}
		}

		final_jolts := max_left_value * 10 + max_right_value
		password += final_jolts
	}

	return password
}

part2 :: proc(banks: []string) -> int {
	password := 0

	for bank in banks {
		jolts := 0
		last_pos := -1
		for batteries_left: int = 12; batteries_left > 0; batteries_left -= 1 {
			// TODO: Rewrite part1 to only convert to int when calculating value
			max_value: u8 = '0'
			for i in (last_pos + 1) ..< (len(bank) - batteries_left + 1) {
				if bank[i] > max_value {
					last_pos = i
					max_value = bank[i]
				}
			}

			digit, ok := strconv.digit_to_int(cast(rune)max_value)
			assert(ok, "Character was not a digit")
			jolts = jolts * 10 + digit
		}
		//fmt.println("jolts:", jolts)
		password += jolts
	}

	return password
}
