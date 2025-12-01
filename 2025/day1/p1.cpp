#include <bits/stdc++.h>
using namespace std;
#define fast_io ios::sync_with_stdio(false);cin.tie(nullptr);

struct Node { int val; Node *prev, *next; Node(int v):val(v),prev(nullptr),next(nullptr){} };

int main(){
    fast_io;
    Node *head=nullptr,*tail=nullptr;
    for(int i=0;i<100;++i){
        Node* n=new Node(i);
        if(!head) head=tail=n;
        else { tail->next=n; n->prev=tail; tail=n; }
    }
    tail->next=head; head->prev=tail;

    Node* current=head;
    while(current->val!=50) current=current->next;

    ifstream f("input.txt");
    long long count=0;
    for(string s; getline(f,s); ){
        if(s.empty()) continue;
        char d=s[0];
        long long x=stoll(s.substr(1));
        x %= 100;
        if(d=='L'){
            for(long long i=0;i<x;++i) current=current->prev;
        } else {
            for(long long i=0;i<x;++i) current=current->next;
        }
        if(current->val==0) ++count;
    }
    cout<<count<<"\n";
    return 0;
}

