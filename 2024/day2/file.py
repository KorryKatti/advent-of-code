def is_valid_line(numbers):
    """Check if a line of numbers is valid."""
    direction = 0
    for i in range(len(numbers) - 1):
        step = numbers[i + 1] - numbers[i]
        if step < -3 or step > 3 or step == 0:
            return False
        if direction == 0:
            direction = 1 if step > 0 else -1
        elif (direction == 1 and step < 0) or (direction == -1 and step > 0):
            return False
    return True


def can_become_valid(numbers):
    """Check if removing one number can make the line valid."""
    for i in range(len(numbers)):
        temp = numbers[:i] + numbers[i + 1:]  # Remove the ith element
        if is_valid_line(temp):
            return True
    return False


def process_line(line):
    """Process a single line of numbers."""
    numbers = list(map(int, line.split()))
    if is_valid_line(numbers) or can_become_valid(numbers):
        return 1
    else:
        print(f"Line is invalid even after removal: {line}")
        return 0


def main():
    """Main function to read input and process lines."""
    lines = [
        "67 69 71 72 75 78 76",
        "4 6 7 9 11 12 12",
        "5 9 2 3 7",  # Example additional lines
    ]
    valid_count = 0

    for line in lines:
        valid_count += process_line(line)

    print(f"Total valid lines after checking removals: {valid_count}")


if __name__ == "__main__":
    main()
