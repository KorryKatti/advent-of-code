#include <bits/stdc++.h>
using namespace std;
#define fast_io ios::sync_with_stdio(false);cin.tie(nullptr);

int main(){
    fast_io;

    ifstream fin("input.txt");

    vector<string> one;
    vector<string> two;
    string line;
    bool innit = false;
    set<long long> sex;

    while (getline(fin, line)){
        if (line == ""){
            innit = true;
            continue;
        }
        if (!innit){
            one.push_back(line);
        } else {
            two.push_back(line);
        }
    }

    vector<pair<long long,long long>> ranges;

    long long totalWork = 0;
    for (auto &s : one) {
        long long L = 0, R = 0;
        bool dash = false;
        for (char c : s) {
            if (c == '-') { dash = true; continue; }
            if (!dash) L = L * 10 + (c - '0');
            else       R = R * 10 + (c - '0');
        }
        ranges.push_back({L, R});
        totalWork += (R - L + 1);
    }

    long long done = 0;

    for (auto &p : ranges) {
        long long L = p.first;
        long long R = p.second;

        for (long long z = L; z <= R; z++) {
            sex.insert(z);
            done++;

            if (done % 1000000 == 0) {
                double pct = (double)done * 100.0 / totalWork;
                cout << "\rProgress: " 
                     << fixed << setprecision(2) 
                     << pct << "%   " << flush;
            }
        }
    }

    cout << "\n" << sex.size() << "\n";
    return 0;
}

