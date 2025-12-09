#include <bits/stdc++.h>
using namespace std;

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);
    
    vector<pair<int, int>> points;
    string line;
    ifstream fin("input.txt");
    
    while (getline(fin, line)) {
        size_t comma = line.find(',');
        if (comma != string::npos) {
            int x = stoi(line.substr(0, comma));
            int y = stoi(line.substr(comma + 1));
            points.push_back({x, y});
        }
    }
    
    long long max_area = 0;
    int n = points.size();
    
    for (int i = 0; i < n; ++i) {
        int x1 = points[i].first, y1 = points[i].second;
        for (int j = i + 1; j < n; ++j) {
            int x2 = points[j].first, y2 = points[j].second;
            long long dx = abs(x1 - x2);
            long long dy = abs(y1 - y2);
            long long area = (dx + 1) * (dy + 1);
            if (area > max_area) {
                max_area = area;
            }
        }
    }
    
    cout << max_area << endl;
    
    return 0;
}
