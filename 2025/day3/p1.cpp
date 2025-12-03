#include <bits/stdc++.h>
using namespace std;
#define fast_io ios::sync_with_stdio(false);cin.tie(nullptr);

int main() {
    fast_io;
    ifstream fin("input.txt");
    long long total = 0;
    string line;
    
    while (getline(fin, line)) {
        int n = (int)line.size();
        int best = 0;
        
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                int tens = line[i] - '0';
                int units = line[j] - '0';
                int val = tens * 10 + units;
                if (val > best) best = val;
            }
        }
        
        total += best;
    }
    
    cout << total << "\n";
    return 0;
}
