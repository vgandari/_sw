% HW3 Test

G = {{2}, {1,3,4},{2,5},{2},{3}}
G = {{2}, {1,3,4},{2,5},{2},{3},{6}}


start = 1;
goal = 5;

parent = computeBFStree(G, start, goal)
path = computeBFSpath(G, start, goal)
