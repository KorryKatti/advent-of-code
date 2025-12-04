#include <bits/stdc++.h>
using namespace std;
#define fast_io ios::sync_with_stdio(false); cin.tie(nullptr);

int main() {
    fast_io;
    vector<string> grid;
    string line;
    ifstream fin("input.txt");

    while (getline(fin, line)) {
        grid.push_back(line);
    }

    int r = grid.size();
    int c = grid[0].size();

    long long count = 0;

    int dr[8] = {-1,-1,-1,0,0,1,1,1};
    int dc[8] = {-1,0,1,-1,1,-1,0,1};

    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {

            if (grid[i][j] != '@') continue;

            int x = 0;
            for (int k = 0; k < 8; k++) {
                int nr = i + dr[k];
                int nc = j + dc[k];

                if (nr >= 0 && nr < r && nc >= 0 && nc < c) {
                    if (grid[nr][nc] == '@') x++;
                }
            }

            if (x < 4) {
                count++;
            }
        }
    }

    cout << count << endl;
}

