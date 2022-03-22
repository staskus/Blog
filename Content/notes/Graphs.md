---
title: Graphs
excerpt: Algorithms
---

## Spanning Tree

A spanning tree is a connected subgraph in an undirected graph where all vertices are connected with the minimum number of edges.

A minimum spanning tree is a spanning tree with the minimum possible total edge weight in a “weighted undirected graph”.

Tree - doesn't have cycles

Cut Property - choosing crossing edge between 2 cuts with the lowest weight

### Minimum Spanning Tree

**“Kruskal’s algorithm”** is an algorithm to construct a “minimum spanning tree” of a “weighted undirected graph”. 1) Take all possible edges 2) sort by weight 3) pick one by one if the cycle is not created (!uf.connected). 

**Prims Algorithm:** - 1) Pick starting node, see which unvisited node we can visit most cheaply. 2) pick visited nodes, see which unvisited node we can visit most cheaply 3) repeat until all nodes are visited. We need to use min-heap to pick the lowest weighted edge
- **Min-heap** - a tree-like data structure, that always stores minimum valued element at the root. Insertion and removal takes logarithmic time
- However, in some cases using min-heap is not effective enough so we need to look ways around it (Min Cost to Connect All Points) as even effective sorting adds log(n) of time complexity. 

Heap is not a Priority Queue, but a way to implement a Priority Queue. 

Heap is a special type of binary tree. Insertion, deletion O(logn). Max, minimum - O(1):
- Min Heap. 
- Max Heap

BFS - Always find the shortest path first. Finding a path in the grid is a usual task. 

## Single source shortest path problem

Edge Relaxation operation is a key in solving the "single source shortest path problem"
- If A-D distance is 3, but A-C-D is 2 by performing edge relaxation we note that the distance between A-D is actually 2

**Dijkstra's algorithm**. Can only be used to solve the problem with non-negative weights

- In time complexity we have 2 properties: V - number of vertices and E - number of edges. If we use the Fibonacci heap to extract minimum element total complexity O(E + VlogV). If we use Binary heap time complexity would be O(V+ ElogV).
- Space complexity O(V)

**Steps:**
1. Start at the ending vertex by marking it with a distance of 0 (call it *currentVertex*)
2. Identify all of the vertices connected to *currentVertex* with weights. If we already identified vertex, only change weight if a new one is smaller
3. Label *currentVertex* as visited
4. Find smallest identifier vertice and repeat 2
5. Once labeled a beginning vertex - stop

**Bellman-Ford algorithm**. Can solve with any weights. 

“Bellman-Ford algorithm” is only applicable to “graphs” with no “negative weight cycles”.

We find a negative cycle if after performing Nth edge relaxation (we normally just need to do N-1) we still find a shorter path. 

- Time complexity O(V * E)
- Space complexity O(V)

Positive Weight Cycle: If during each cycle the path weight increases. The shortest path is after the first cycle

Negative Weight Cycle: If during each cycle the path weight decreases. There's no shortest path then


**Bellman-Ford:**
1. Have previous and current arrays
2. Each iteration simply set current cost to be minimum of already existing or previous + cost current[destination] = min(current[destination], previous[origin] + cost)
3. At the end of iteration set previous = current

Essentially, **Bellman-Ford** algorithm is a dynamic programming solution optimized for space and time. If 2 loops in the row we get the same result, we can return it as the shortest path. 

If a question has a constraint of going through k edges, then we just use a dynamic programming approach

## Dynamic Programming

**Dynamic Programming (DP)** is an algorithmic technique for solving an optimization problem by breaking it down into simpler subproblems and utilizing the fact that the optimal solution to the overall problem depends upon the optimal solution to its subproblems.

Solving shortest path problem using Dynamic Programming:
- Asking: Can I find the shortest path using at most 1 edge? Can I find the shortest path using at most 2 edges, etc until N-1 edges

**Dynamic Programming:**
1. Look if the same problem can be split into some smaller problems in a tree structure. Then it means we can solve it using recursion. We need to know the base case to return early from recursion.
2. Make it work brute force way
3. Optimize it using “memoization” (creating dict or set for efficiency)
