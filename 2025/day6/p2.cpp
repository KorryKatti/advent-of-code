/* i am just doing in excel what even is the point of code then*/

/* i understand that this has got to do something with place values of the digits*/

#include <bits/stdc++.h>
using namespace std;

int main() {
    ifstream fin("input.txt");
    vector<string> grid;
    string line;
    
    while (getline(fin, line)) {
        grid.push_back(line);
    }
    
    int rows = grid.size();
    int cols = grid[0].size();
    
    vector<int> operator_cols;
    for (int col = 0; col < cols; col++) {
        if (grid[rows-1][col] == '+' || grid[rows-1][col] == '*') {
            operator_cols.push_back(col);
        }
    }
    
    long long grand_total = 0;
    
    for (int op_col : operator_cols) {
        int right = op_col;
        while (right < cols - 1) {
            bool all_spaces = true;
            for (int row = 0; row < rows; row++) {
                if (grid[row][right+1] != ' ') {
                    all_spaces = false;
                    break;
                }
            }
            if (all_spaces) break;
            right++;
        }
        
        vector<long long> nums;
        for (int col = op_col; col <= right; col++) {
            string num_str = "";
            for (int row = 0; row < rows - 1; row++) {
                if (grid[row][col] != ' ') {
                    num_str += grid[row][col];
                }
            }
            if (!num_str.empty()) {
                nums.push_back(stoll(num_str));
            }
        }
        
        reverse(nums.begin(), nums.end());
        
        char op = grid[rows-1][op_col];
        long long result;
        if (op == '+') {
            result = 0;
            for (long long n : nums) result += n;
        } else {
            result = 1;
            for (long long n : nums) result *= n;
        }
        
        grand_total += result;
    }
    
    cout << grand_total << endl;
    return 0;
}


/* this took so mch help lmao anyawys donew*/
