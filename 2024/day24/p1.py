# Inspired by elegant solutions from https://github.com/Grecil/ElegantAoC24/
# Advent of Code 2024 - Day 24 Solution

def read_input(file_path):
    initial_values = {}
    gates = []

    with open(file_path, 'r') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            if ':' in line:
                wire, value = line.split(': ')
                initial_values[wire] = int(value)
            else:
                gates.append(line)

    return initial_values, gates


def simulate_system(initial_values, gates):
    wire_values = initial_values.copy()
    gate_operations = {}

    for gate in gates:
        inputs, output = gate.split(' -> ')
        gate_operations[output] = inputs

    def evaluate_wire(wire):
        if wire in wire_values:
            return wire_values[wire]

        operation = gate_operations[wire]
        parts = operation.split()

        if len(parts) == 1:
            value = evaluate_wire(parts[0])
        elif len(parts) == 3:
            left, op, right = parts
            left_val = evaluate_wire(left)
            right_val = evaluate_wire(right)

            if op == 'AND':
                value = left_val & right_val
            elif op == 'OR':
                value = left_val | right_val
            elif op == 'XOR':
                value = left_val ^ right_val
            else:
                raise ValueError(f"Unknown operation: {op}")
        else:
            raise ValueError(f"Unexpected gate format: {operation}")

        wire_values[wire] = value
        return value

    z_wires = sorted([wire for wire in gate_operations if wire.startswith('z')])
    z_values = [evaluate_wire(wire) for wire in z_wires]

    binary_number = ''.join(map(str, z_values[::-1]))
    return int(binary_number, 2)


if __name__ == "__main__":
    input_file = "input.txt"
    initial_values, gates = read_input(input_file)
    result = simulate_system(initial_values, gates)
    print("result :", result)
