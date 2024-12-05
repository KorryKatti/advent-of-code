def load_rules(filename):
    with open(filename, 'r') as file:
        rules = [tuple(map(int, line.strip().split('|'))) for line in file.readlines()]
    return rules

def load_pages(filename):
    with open(filename, 'r') as file:
        pages = [list(map(int, line.strip().split(','))) for line in file.readlines()]
    return pages

def is_valid_sequence(pages, rules):
    for i in range(len(pages) - 1):
        for rule in rules:
            if pages[i] == rule[0] and pages[i + 1] == rule[1]:
                break
        else:
            return False
    return True

def main():
    # Load the rules and pages from files
    rules = load_rules('rules.txt')
    pages = load_pages('pages.txt')

    # Filter out the valid and invalid pages
    invalid_pages = [page for page in pages if not is_valid_sequence(page, rules)]

    # Write invalid pages to invalid.txt
    with open('invalid.txt', 'w') as file:
        for page in invalid_pages:
            file.write(','.join(map(str, page)) + '\n')

    print(f"Invalid pages have been written to 'invalid.txt'.")

if __name__ == "__main__":
    main()
