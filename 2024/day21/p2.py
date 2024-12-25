# Inspiration from https://github.com/Grecil/ElegantAoC24
from functools import cache
from random import random

class KeypadSolver:
    def __init__(self):
        self.numpad = {
            "7": (0, 0), "8": (0, 1), "9": (0, 2),
            "4": (1, 0), "5": (1, 1), "6": (1, 2),
            "1": (2, 0), "2": (2, 1), "3": (2, 2),
            " ": (3, 0), "0": (3, 1), "A": (3, 2)
        }
        self.keypad = {
            " ": (0, 0), "^": (0, 1), "A": (0, 2),
            "<": (1, 0), "v": (1, 1), ">": (1, 2)
        }

    @staticmethod
    def xdir(x: int) -> str:
        return "v" if x > 0 else "^"
    
    @staticmethod
    def ydir(x: int) -> str:
        return ">" if x > 0 else "<"

    @cache
    def get_moves(self, curr: str, new: str) -> str:
        pad = self.keypad if (new in self.keypad and curr in self.keypad) else self.numpad
        dist = (pad[new][0] - pad[curr][0], pad[new][1] - pad[curr][1])
        ret = self.xdir(dist[0]) * abs(dist[0]) + self.ydir(dist[1]) * abs(dist[1])
        if pad[" "] == (pad[new][0], pad[curr][1]):
            return ret[::-1] + "A"
        if pad[" "] == (pad[curr][0], pad[new][1]):
            return ret + "A"
        return (ret if random() < 0.5 else ret[::-1]) + "A"

    @cache
    def score_sequence(self, seq: str, depth: int, curr: int = 0) -> int:
        if depth == 0:
            return len(seq)
        
        total = 0
        for i, key in enumerate(seq):
            total += self.score_sequence(self.get_moves(seq[i-1], key), depth - 1)
        return total

    def solve(self, sequences: list[str], num_robots: int = 26, iterations: int = 500) -> int:
        total = 0
        
        for seq in sequences:
            min_score = float("inf")
            numeric_value = int(seq[:-1])
            
            for _ in range(iterations):
                self.get_moves.cache_clear()
                self.score_sequence.cache_clear()
                
                score = self.score_sequence(seq, num_robots) * numeric_value
                min_score = min(min_score, score)
            
            total += min_score
            
        return total

def main():
    solver = KeypadSolver()
    
    sequences = [line.strip() for line in open('input.txt', 'r')]
    
    result = solver.solve(sequences)
    print(f"Result: {result}")

if __name__ == "__main__":
    main()