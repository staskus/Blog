---
title: Trees and Graphs
excerpt: Data Structures
---

# Trees

**Tree** - a data structure composed of nodes. Each tree has a root node, each child has zero or more child nodes and doesn't have cycles.

**Leaf Node** - a node with no children.

## Binary trees

**Binary Tree** - each node has up to two children.

**Binary Search Tree** - when *every* node is specifically ordered. 

**Complete Binary Tree** - every level is filled except the last level. Last level filling from left to right.

**Full Binary Tree** - each node has either zero or two children

**Perfect Binary Tree** - full, complete and all nodes at the same level.

### Traversal

#### In-Order
First visit the left branch, then the current node then the right branch.
```swift
func traverseInOrder(_ node: Node?) {
    if let node = node {
        traverseInOrder(node?.left)
        visit(node) // for example just print
        traverseInOrder(node?.right)
    }
}
```

#### Pre-Order
First visit the current node, then the others.
```swift
func traversePreOrder(_ node: Node?) {
    if let node = node {
        visit(node)
        traversePreOrder(node?.left)
        traversePreOrder(node?.right)
    }
}
```

#### Post-Order
First visit left and right branches, then the current node.
```swift
func traversePostOrder(_ node: Node?) {
    if let node = node {
        traversePostOrder(node?.left)
        traversePostOrder(node?.right)
        visit(node)
    }
}
```

## Balancing

**Balanced tree** - doesn't mean that right and left sides are of the same size. It means that its balance might allow for specific effective operations such as O(log n) insert and find.

## Binary Heaps

**Min-heap** - is a complete binary tree where each node is smaller than its children. The root is the minimum element in the tree.

### Insert

We insert at the rightmost empty spot and then go up by swapping with the parent until it's smaller than its parent.

O(log n)

### Get Minimum Element

It's always at the top.

### Remove Minimum Element

1. Remove the top element
2. Replace it with the bottommost-rightmost element
3. Go from the top to the bottom swapping it with the children until it reaches its place

O(log n)

## Trie (Prefix Tree)

An n-ary tree where characters are stored at each node. * node indicates a complete word. Each node can have children the number of the size of the alphabet.

Usage:
* Storing the entire language for quick prefix lookups. 
* Lists of valid words


# Graphs

A graph is a collection of nodes with edges between some of them.

**Connected graph** - if there's a path between every pair of vertices.

**Acyclic graph** - a graph without cycles

## Adjacency List

A way to represent a graph

```swift
class Graph {
    var nodes: [Node]
}

class Node {
    var val: Int
    var children: [Node]
}
```

## Adjacency Matrix

```swift
matrix[i][j] == true // represents that there's an edge between i and j nodes
```

## Search

### Depth-first search (DFS)

Explore each branch completely before moving to the next branch, meaning going deep first.

DFS is to visit every node in the graph.

To implement we can use recursion or a stack (which recursion uses underneath).

```swift
    func searchDFS(_ root: Node?) {
        guard let root = root else { return }

        visit(root)
        root.visited = true

        for node in root.children {
            if !node.visited {
                seachDFS(node)
            }
        }
    }
```

### Breadth-first search (BFS)

Explore each neighbor before moving to the children, meaning going wide first.

BFS is used to find the shortest (or any) path between 2 nodes.

To implement we need to use a queue (FIFO) data structure to ensure we search wide first.

```swift
    func searchBFS(_ root: Node?) {
        guard let root = root else { return }

        let queue = Queue()
        root.marked = true
        queue.enqueue(root) // Add to the end

        while !queue.isEmpty {
            let node = queue.dequeue() // Take from the front
            visit(node)

            for child in node.children {
                if !child.marked {
                    child.marked = true
                    queue.enqueue(child)
                }
            }
        }
    }
```

3 facts to know about BFS:
1. Inorder traversal of BST is an array sorted in the ascending order.
2. Successor = "after node", i.e. the next node, or the smallest node after the current one.
3. Predecessor = "before node", i.e. the previous node, or the largest node before the current one.

### Bidirectional Search

Find the shorted path between 2 nodes by performing 2 simultaneous BFS from both nodes.

## Example problems to know how to solve:

### Convert Sorted Array to Binary Search Tree

Keep splitting the sorted array in half so the root would be the middle element.

```swift
// O(n) time complexity, O(logn) space complexity

class Solution {
    func sortedArrayToBST(_ nums: [Int]) -> TreeNode? {
        return createMinimalBST(nums, start: 0, end: nums.count - 1)
    }
    
    private func createMinimalBST(_ nums: [Int], start: Int, end: Int) -> TreeNode? {
        guard start <= end else { return nil }
        
        let mid = ((start + end) / 2)
    
        return TreeNode(
            nums[mid],
            createMinimalBST(nums, start: start, end: mid - 1),
            createMinimalBST(nums, start: mid + 1, end: end)
            )
    }
}
```

# Additional Information

## Spanning Tree

A spanning tree is a connected subgraph in an undirected graph where all vertices are connected with the minimum number of edges.

A minimum spanning tree is a spanning tree with the minimum possible total edge weight in a “weighted undirected graph”.

Tree - doesn't have cycles

Cut Property - choosing crossing edge between 2 cuts with the lowest weight

### Minimum Spanning Tree

**“Kruskal’s algorithm”** is an algorithm to construct a “minimum spanning tree” of a “weighted undirected graph”. 1) Take all possible edges 2) sort by weight 3) pick one by one if the cycle is not created (!uf.connected). 

**Prims Algorithm:** - 1) Pick starting node, see which unvisited node we can visit most cheaply. 2) pick visited nodes, see which unvisited node we can visit most cheaply 3) repeat until all nodes are visited. We need to use min-heap to pick the lowest weighted edge
- However, in some cases using min-heap is not effective enough so we need to look ways around it (Min Cost to Connect All Points) as even effective sorting adds log(n) of time complexity. 

Heap is not a Priority Queue, but a way to implement a Priority Queue. 

Heap is a special type of binary tree. Insertion, deletion O(log n). Max, minimum - O(1):
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
