/# NOTE: If a comment is below a line of text, then it is not recognised as a comment
 #       for an unknown reason.
 #/

#c : char := 'c';
#c2 : char := 'C';
#i : int := 0;
#t : top := 42;
#r : rat := 345_11/3;
#b : bool := T;
#d : dict<int, char> := { 1:'1', 2:'2', 3:'3'};
#s : seq<rat> := [ 1/2, 3, 4_2/17, -7 ];
#s2 : seq<int> := [-894535, 2434543, -32435, 43345354];
#s3 : seq<char> := ['a', 'b', 'c', 'd'];
#s4 : seq<bool> := [T, F, F, F, T];
#s5 : seq<float> := [-1, 2, -1.45, 56.89];
#s6 : seq<float> := [1, 2, 3, 4, 5, 3453458798437598.4905809438509];
#s7 : seq<top> := [1, 3, 5.4689, 'a', 'b', 'c', T, T, F, ['a', 'b', 'c', 'd']];
#s8 : seq<top> := [1, 1/2, 3.14, [ 1/2, 345_11/3, 'u', 'r']];
#s9 : seq<top> := [1, 2, 'a', 'b', 11231234.3242345, T, F, [1, 2, [3, 4, 'a', 'b', [345_11/3, 2/5]]]];
#d3 : dict<char, int> := ['a':1, 'b':2, 'c':3];
#d4 : dict<int, top> := [1:'a', 2:3, 3:T, 4:5435345.345345, 5:5_8/33];
#d1 : dict< int , char > := [1:'a', 2:'b', 3:'c', 4:'d'];
#d2 : dict< int , int > := [1:2, 2:3, 3:4, 4:5];
#d5 : dict<int, top> := {1:'a', 2:3, 3:T, 4:5435345.345345, 5:5_8/33, {1:T}};
