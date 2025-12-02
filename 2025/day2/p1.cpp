#include <bits/stdc++.h>
using namespace std;

#define fast_io ios::sync_with_stdio(false); cin.tie(nullptr);

int main() {
    fast_io;

    ifstream f("input.txt");
    long long sum = 0;

    string line;
    getline(f, line);   

    stringstream ss(line);
    string range;

    while (getline(ss, range, ',')) { 
        stringstream rs(range);
        string a_str, b_str;

        getline(rs, a_str, '-');
        getline(rs, b_str, '-');

        long long a = stoll(a_str);
        long long b = stoll(b_str);

        if (a > b) swap(a, b);

        for (long long i = a; i <= b; ++i) {
            string s = to_string(i);
            int L = s.length();

            if (L % 2 != 0) continue;     

            int k = L / 2;
            if (s.substr(0, k) == s.substr(k, k)) {
                sum += i;               
            }
        }
    }

    cout << sum;
    return 0;
}

