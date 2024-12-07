import itertools

def calculate_expression(numbers, ops):
    result = numbers[0]
    for i in range(len(ops)):
        if ops[i] == "+":
            result += numbers[i+1]
        elif ops[i] == "*":
            result *= numbers[i+1]
        elif ops[i] == "||":
            result = int(str(result) + str(numbers[i+1]))
    return result

with open("input.txt") as f:
    result = sum(int(target) for line in f for target, numbers in [line.split(": ")] 
                 for target in [int(target)] 
                 for numbers in [[int(x) for x in numbers.split()]] 
                 if any(calculate_expression(numbers, ops) == target 
                        for ops in itertools.product(["+", "*", "||"], repeat=len(numbers)-1)))

print("Total Calibration Result:", result)
