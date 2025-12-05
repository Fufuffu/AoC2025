package day2

import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:strings"

Range :: struct {
	start: int,
	end:   int,
}

RANGES := [1024]Range{}
RANGE_COUNT := 0

main :: proc() {
	data, err := os2.read_entire_file("day5/input.txt", context.allocator)
	if (err != os2.ERROR_NONE) {
		fmt.eprintln("Could not read file:", err)
		os2.exit(1)
	}

	data_str := transmute(string)data
	fmt.println("The password (part1) is:", part1(data_str))
	//fmt.println("The password (part2) is:", part2(data_str))
}

part1 :: proc(data: string) -> int {
	data := data
	password := 0

	processed_ranges := false
	for line in strings.split_lines_iterator(&data) {
		if line == "" {
			processed_ranges = true
			continue
		}

		if !processed_ranges {
			ids := strings.split(line, "-")
			assert(len(ids) == 2)

			start, ok := strconv.parse_int(ids[0])
			end, ok2 := strconv.parse_int(ids[1])
			assert(ok && ok2, "could not parse ints")

			RANGES[RANGE_COUNT] = Range{start, end}
			RANGE_COUNT += 1
		} else {
			num_to_check, ok := strconv.parse_int(line)
			assert(ok, "could not parse int")

			for i in 0 ..< RANGE_COUNT {
				range := RANGES[i]
				if range.start <= num_to_check && num_to_check <= range.end {
					password += 1
					break
				}
			}
		}
	}
	return password
}
