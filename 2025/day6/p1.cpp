#include <bits/stdc++.h>
using namespace std;
#define fast_io ios::sync_with_stdio(false);cin.tie(nullptr);

static inline bool is_digit(char c) {
    return c >= '0' && c <= '9';
}

int main(){
    fast_io;
    vector<string> grid;
    string line;
    ifstream fin("input.txt");

    while (getline(fin, line)) {
        grid.push_back(line);
    }


    int r = grid.size();
    int c = grid[0].size();
    long long sum = 0;

    vector<char> symbols(c);
    for (int i = 0; i < c; i++) {
        symbols[i] = grid[r - 1][i];
    }

    for (int col = 0; col < c; col++) {
        char op = symbols[col];

        if (op != '+' && op != '*') {
            continue;
        }

        long long current = 0;
        bool first_value = true;

        for (int row = 0; row < r - 1; row++) {
            char ch = grid[row][col];

            if (!is_digit(ch)) {
                continue;
            }

            long long val = ch - '0';

            if (first_value) {
                current = val;
                first_value = false;
                continue;
            }

            if (op == '+') {
                current += val;
            } else {
                current *= val;
            }
        }

        if (!first_value)
            sum += current;
    }

    cout << sum << "\n";
}

