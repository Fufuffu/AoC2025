package day2

import "core:fmt"
import "core:os/os2"
import "core:strconv"
import "core:strings"

STR_BUF := [1024]u8{}

main :: proc() {
	data, err := os2.read_entire_file("day2/input.txt", context.allocator)
	if (err != os2.ERROR_NONE) {
		fmt.eprintln("Could not read file:", err)
		os2.exit(1)
	}

	ranges := strings.split(strings.trim(transmute(string)data, "\r\n"), ",")
	fmt.println("The password (part2) is:", solve(ranges))
}

solve :: proc(ranges: []string) -> int {
	total_invalids := 0

	for range in ranges {
		ids := strings.split(range, "-")
		assert(len(ids) == 2)

		start_id, ok := strconv.parse_int(ids[0])
		end_id, ok2 := strconv.parse_int(ids[1])
		assert(ok && ok2, "could not parse ints")

		for num in start_id ..= end_id {
			if is_invalid_part2(num) {
				total_invalids += num
			}
		}
	}

	return total_invalids
}

is_invalid_twice :: proc(num: int) -> bool {
	str_num := strconv.write_int(STR_BUF[:], i64(num), 10)
    // Odd length cannot have a mirrored part
    if len(str_num) % 2 != 0 do return false

    half_len := len(str_num) / 2
    return str_num[0:half_len] == str_num[half_len:len(str_num)]
}

is_invalid_part2 :: proc(num: int) -> bool {
	str_num := strconv.write_int(STR_BUF[:], i64(num), 10)

	for bucket_size := 1; bucket_size < len(str_num); bucket_size += 1 {
		bucket := str_num[0:bucket_size]
		iterator := bucket_size

		possible_invalid := true
		for iterator < len(str_num) {
            if iterator + bucket_size > len(str_num) do break
			if bucket != str_num[iterator:iterator + bucket_size] {
				possible_invalid = false
				break
			}
			iterator += bucket_size
		}

		if possible_invalid && iterator == len(str_num) {
			return true
		}
	}
	return false
}
