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

def get_middle(page_list):
    # Calculate and return the middle element of a list
    n = len(page_list)
    return page_list[n // 2] if n % 2 == 1 else (page_list[n // 2 - 1] + page_list[n // 2]) // 2

def main():
    # Load the rules
    rules = load_rules('rules.txt')
    
    # Load the corrected pages from output2.txt
    corrected_pages = load_pages('output2.txt')

    # Get the middle elements of the corrected pages
    middle_elements = [get_middle(page) for page in corrected_pages]

    # Sum the middle elements
    total_sum = sum(middle_elements)

    # Print the result
    print(f"Sum of middle elements: {total_sum}")

if __name__ == "__main__":
    main()
