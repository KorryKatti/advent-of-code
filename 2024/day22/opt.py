def process_secret(number):
    number = mix_and_prune(number, number * 64)
    number = mix_and_prune(number, number // 32)
    number = mix_and_prune(number, number * 2048)
    return number

def mix_and_prune(secret, value):
    return (secret ^ value) % 16777216

def generate_sequences_and_prices(initial_secret, count):
    current = initial_secret
    prices = [current % 10]
    for _ in range(count):
        current = process_secret(current)
        prices.append(current % 10)
    changes = [prices[i] - prices[i-1] for i in range(1, len(prices))]
    sequences = {}
    for i in range(len(changes) - 3):
        seq = tuple(changes[i:i+4])
        if seq not in sequences:
            sequences[seq] = prices[i+4]
    return sequences

def find_best_sequence():
    with open('input.txt', 'r') as file:
        initial_secrets = [int(line.strip()) for line in file if line.strip()]
    buyer_sequences = []
    all_unique_sequences = set()
    for secret in initial_secrets:
        sequences = generate_sequences_and_prices(secret, 2000)
        buyer_sequences.append(sequences)
        all_unique_sequences.update(sequences.keys())
    best_sequence, max_bananas = None, 0
    for sequence in all_unique_sequences:
        total_bananas = sum(buyer_seqs.get(sequence, 0) for buyer_seqs in buyer_sequences)
        if total_bananas > max_bananas:
            max_bananas = total_bananas
            best_sequence = sequence
    return best_sequence, max_bananas

best_sequence, max_bananas = find_best_sequence()
print(max_bananas)
