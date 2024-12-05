def load_rules(filename):
    with open(filename, 'r') as file:
        rules = [tuple(map(int, line.strip().split('|'))) for line in file.readlines()]
    return rules

def load_pages(filename):
    with open(filename, 'r') as file:
        pages = [list(map(int, line.strip().split(','))) for line in file.readlines()]
    return pages

def reorder_pages(pages, rules):
    # Repeatedly apply the rules until no more changes
    changed = True
    while changed:
        changed = False
        for rule in rules:
            page_before, page_after = rule
            if page_before in pages and page_after in pages:
                index_before = pages.index(page_before)
                index_after = pages.index(page_after)
                if index_before > index_after:
                    # Swap the pages to respect the rule
                    pages.remove(page_before)
                    pages.insert(index_after, page_before)
                    changed = True
    return pages

def main():
    # Load the rules and pages
    rules = load_rules('rules.txt')
    invalid_pages = load_pages('invalid.txt')

    # Reorder each invalid page according to the rules
    corrected_pages = [reorder_pages(page.copy(), rules) for page in invalid_pages]

    # Write the corrected pages to output2.txt
    with open('output2.txt', 'w') as file:
        for page in corrected_pages:
            file.write(','.join(map(str, page)) + '\n')

    print(f"Corrected pages have been written to 'output2.txt'.")

if __name__ == "__main__":
    main()
