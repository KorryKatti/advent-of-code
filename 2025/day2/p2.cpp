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
        string a_str, b_str;
        stringstream rs(range);
        getline(rs, a_str, '-');
        getline(rs, b_str, '-');
        long long a = stoll(a_str);
        long long b = stoll(b_str);
         
        for (long long i = a; i <= b; ++i) {
            string s = to_string(i);
            int L = s.length();
            bool invalid = false;
            
            for (int len = 1; len <= L / 2; ++len) {
                if (L % len == 0) {
                    string pattern = s.substr(0, len);
                    bool match = true;
                    for (int j = len; j < L; j += len) {
                        if (s.substr(j, len) != pattern) {
                            match = false;
                            break;
                        }
                    }
                    if (match) {
                        invalid = true;
                        break;
                    }
                }
            }
            
            if (invalid) sum += i;
        }
    }
    
    cout << sum;
    return 0;
}
