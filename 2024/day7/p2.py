import itertools

def parse_line(line):
    target, numbers_str = line.split(": ")
    target = int(target)
    numbers = list(map(int, numbers_str.split()))
    return target, numbers

def evaluate_expression(numbers, operators):
    result = numbers[0]
    for i in range(len(operators)):
        op = operators[i]
        next_num = numbers[i + 1]
        if op == "+":
            result += next_num
        elif op == "*":
            result *= next_num
        elif op == "||":
            result = int(str(result) + str(next_num))
    return result

def solve_part_two(input_data):
    operators = ["+", "*", "||"]
    valid_targets = []
    for line in input_data:
        target, numbers = parse_line(line)
        operator_combinations = itertools.product(operators, repeat=len(numbers) - 1)
        for op_list in operator_combinations:
            if evaluate_expression(numbers, op_list) == target:
                valid_targets.append(target)
                break
    return sum(valid_targets)

def read_input_file(filename):
    with open(filename, 'r') as file:
        return file.readlines()

if __name__ == "__main__":
    input_file = "input.txt"
    input_data = read_input_file(input_file)
    result = solve_part_two(input_data)
    print("Total Calibration Result:", result)
