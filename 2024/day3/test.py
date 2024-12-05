import re

def find_valid_mul(text):
    match = re.match(r"mul\((\d{1,3}),(\d{1,3})\)", text)
    if match:
        return int(match.group(1)) * int(match.group(2))
    return None


def main():
    with open("input.txt", "r") as file:
        content = file.read()

    total = 0
    for i in range(len(content)):
        result = find_valid_mul(content[i:])
        if result is not None:
            print(f"Found mul: {content[i:i+10]} = {result}")
            total += result

    print(f"\nTotal sum of multiplications: {total}")


if __name__ == "__main__":
    main()