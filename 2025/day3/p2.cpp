#include <bits/stdc++.h>
using namespace std;

string find_best_12_digits(const string &line) {
    int n = line.size();
    string result;
    int start = 0;
    
    for (int picked = 0; picked < 12; ++picked) {
        int remaining = 12 - picked;
        int searchEnd = n - remaining;
        
        char best = '0';
        int bestPos = start;
        for (int i = start; i <= searchEnd; ++i) {
            if (line[i] > best) {
                best = line[i];
                bestPos = i;
            }
        }
        
        result.push_back(best);
        start = bestPos + 1;
    }
    
    return result;
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    
    ifstream fin("input.txt");
    string line;
    long long total = 0;
    
    while (getline(fin, line)) {
        if (line.size() < 12) continue;
        
        string best = find_best_12_digits(line);
        long long val = stoll(best);
        total += val;
    }
    
    cout << total << "\n";
    return 0;
}
