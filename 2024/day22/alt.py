from itertools import product

def process_secret(number):
    number = mix_and_prune(number, number * 64)
    number = mix_and_prune(number, number // 32)
    number = mix_and_prune(number, number * 2048)
    return number

def mix_and_prune(secret, value):
    mixed = secret ^ value
    return mixed % 16777216

def generate_price_changes(initial_secret, count):
    prices = []
    current = initial_secret
    prices.append(current % 10)
    for _ in range(count):
        current = process_secret(current)
        prices.append(current % 10)
    changes = [prices[i] - prices[i-1] for i in range(1, len(prices))]
    return changes, prices

def find_sequence_value(changes, prices, target_sequence):
    sequence_len = len(target_sequence)
    for i in range(len(changes) - sequence_len + 1):
        if changes[i:i+sequence_len] == target_sequence:
            return prices[i + sequence_len]
    return 0

def find_best_sequence():
    with open('input.txt', 'r') as file:
        initial_secrets = [int(line.strip()) for line in file if line.strip()]
    all_buyer_data = []
    for secret in initial_secrets:
        changes, prices = generate_price_changes(secret, 2000)
        all_buyer_data.append((changes, prices))
    possible_changes = range(-9, 10)
    max_bananas = 0
    for sequence in product(possible_changes, repeat=4):
        total_bananas = 0
        for changes, prices in all_buyer_data:
            total_bananas += find_sequence_value(changes, prices, sequence)
        if total_bananas > max_bananas:
            max_bananas = total_bananas
    return max_bananas

print(find_best_sequence())
