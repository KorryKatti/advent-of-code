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

    for (int i = 0; i < (int)one.size(); i++){
        string s = one[i];
        long long L = 0, R = 0;
        int j = 0;
        bool lmao = false;

        while (j < s.size()){
            if (!lmao){
                if (s[j] == '-') {
                    lmao = true;
                } else {
                    L = L * 10 + (s[j] - '0');
                }
            } else {
                R = R * 10 + (s[j] - '0');
            }
            j++;
        }

        ranges.push_back({L, R});
    }

    long long ans = 0;

    for (int i = 0; i < (int)two.size(); i++){
        string s = two[i];
        if (s == "") continue;

        long long x = 0;
        for (char c : s){
            x = x * 10 + (c - '0');
        }

        bool fresh = false;

        for (auto &p : ranges){
            if (x >= p.first && x <= p.second){
                fresh = true;
                break;
            }
        }

        if (fresh) ans++;
    }

    cout << ans << "\n";
    return 0;
}

