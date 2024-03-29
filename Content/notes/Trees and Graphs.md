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
2. Successor = "after node", i.e. the next node in "In order traversal (Left -> Node -> Previous)", or the smallest node after the current one.
3. Predecessor = "before node", i.e. the previous node "In order traversal (Left -> Node -> Previous)", or the largest node before the current one.

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

### Given a binary tree, return the level order traversal of its nodes

It can be done using a simple recursion or a BFS. BFS allows printing easier level by level. In both cases, we need to save the "level" in the queue or pass it during the recursion.

### Check if Binary Tree is balanced

A balanced tree is defined to be a tree such that the heights of the two subtrees of any node never differ by more than one. 

Calculating the height of each branch is not fully effective. We need to introduce an "early exit" the moment we find one branch not being balanced.

```swift
// O(N) time and O(H) space because of the early exit
// We first go as deep left as possible and then increase the height when going up. The moment we find the difference between left and right more than 1, we throw an error.
class Solution {
    enum TreeError: Error {
        case notBalanced
    }
    
    func isBalanced(_ root: TreeNode?) -> Bool {
        guard let root = root else { return true }
        
        do {
            try checkHeight(root)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    private func checkHeight(_ root: TreeNode?) throws -> Int {      
        guard let root = root else { return -1 }

        let left = try checkHeight(root.left) // Throwing error as an early exit
        let right =  try checkHeight(root.right)
        
        if (abs(left - right) < 2) {
            return max(left, right) + 1
        } else {
            throw TreeError.notBalanced
        }
    }
}
```

### Validate Binary Search Tree

```
A valid BST is defined as follows:

* The left subtree of a node contains only nodes with keys less than the node's key.
* The right subtree of a node contains only nodes with keys greater than the node's key.
* Both the left and right subtrees must also be binary search trees.
```

![Leetcode.com](/images/notes/86b326043320bbd1a5d8d05117e1187489c2d15b285e3a773dd4476c23e2dc14.png)  


We have 2 main routes to take.

First one is more intuitive, traverse the tree recursively, passing valid ranges and then validating them against the current value:

```swift
// O(n), O(n)
func isValidBST(_ root: TreeNode?) -> Bool {
    guard let root = root else { return true }
    
    return isValidBST(root.left, -Int.max..<root.val) && isValidBST(root.right, root.val+1..<Int.max)
}

private func isValidBST(_ root: TreeNode?, _ allowedRange: Range<Int>) -> Bool {
    guard let root = root else { return true }
            
    if !allowedRange.contains(root.val) {
        return false
    }
    
    return isValidBST(root.left, allowedRange.lowerBound..<root.val) && isValidBST(root.right, root.val+1..<allowedRange.upperBound)
}
```

Using DFS Inorder traversal is a more interesting solution. `Left -> Node -> Right`. Traversing like this we expect each node to have a larger value if it is a binary search tree. 

```swift
// O(n), O(n)
private var previous: Int?

func isValidBST(_ root: TreeNode?) -> Bool {
guard let root = root else { return true }
    
    // Left
    if !isValidBST(root.left) {
        return false
    }
    
    // Node
    if let previous = previous, previous >= root.val {
        return false
    }
    previous = root.val
    
    // Right
    if !isValidBST(root.right) {
        return false
    }
    
    return true
}
```

### Find a successor (next node) in a binary search tree


* Successor = "after node", i.e. the next node in the inorder traversal, or the smallest node after the current one.

* Predecessor = "before node", i.e. the previous node in the inorder traversal, or the largest node before the current one.

So to find a successor we either need to go:
- One right node and as many left nodes as possible
- If no right node exists, go up the tree until the node is the left child of the parent and return the parent

### Course Schedule

Given the list of courses and dependency list of which courses must come before the others, return a list of course order.

This issue can be solved with DFS with some caveats.
* We might not have one graph, there might be multiple graphs. So we might need to do multiple DFS until all nodes (courses) have been visited.
* Once we reach the end of the graph then we add that node to the **beginning** of the course schedule.
* If cycles are found, it's impossible to create a schedule. Cycles can be avoided by **visited** and **visiting** (or gray and black) node marking.

### Lowest Common Ancestor in a Binary Tree of 2 nodes

The idea is to do a DFS recursive search throughout the tree. At each point we make 2 recursive calls (to the left and to the right). At the moment where **both** left and right branches result in a node being found, or any of the branches result in a node being found **and** the current node is a node we are looking for, we return a node.

```swift
// O(n), O(n)
private func findNode(from node: TreeNode?, to p: TreeNode, orTo q: TreeNode) -> Bool {
    guard let node = node else {
        return false
    }
    
    let left = findNode(from: node.left, to: p, orTo: q) ? 1 : 0
    let right = findNode(from: node.right, to: p, orTo: q) ? 1 : 0
    let current = node.val == p.val || node.val == q.val ? 1 : 0
    
    // If any two are correct
    if left + right + current >= 2 {
        ancestor = node
    }
    
    return left + right + current > 0
}
```

### Number of Ways to Reorder Array to Get Same BST

How many times we can reorder the same given array to get the same BST.

The intuition:
* The first array element needs to be the same to have the same root
* Smaller elements need to keep the same relative position to other small elements
* Larger elements need to keep the same relative position to other large elements

The solution:
* Divide and conquer. Keep splitting given array into 2 arrays with larger numbers than the first one and smaller numbers than the first one. Calculate the number of combination for each array
* Combinatorics nCk (to find the number of ways selecting k things out of n things)
* Multiply all the results recursively

Problems in Swift:
* No built-in way to calculate nCk
* No built-in way to calculate using large numbers BigInt

The gist of the algorithm
```swift
func numOfWays(_ nums: [Int]) -> Int {
    func divideAndConquer(_ sublist: [Int]) -> Int {
        if sublist.count <= 2 {
            return 1 // base case
        }
        
        let root = sublist[0]
        
        let left = sublist.filter { $0 < root }
        let right = sublist.filter { $0 > root }
        
        return nCk(left.count + right.count, left.count) * divideAndConquer(left) * divideAndConquer(right)
    }
    
    return (divideAndConquer(nums) - 1) // With big trees the result will overflow
}

func nCk(_ n: Int, _ k: Int) -> Int {
    //C (n , k) = n! / [ (n-k)! k! ]
    
    if (k > n) { return 0 }
    var result = 1
    for i in 0..<min(k, n-k) {
        result = (result * (n - i))/(i + 1)
    }
    return result
}
```

### Path Sum

Given the root of a binary tree and an integer targetSum, return the number of paths where the sum of the values along the path equals targetSum.

This problem can be solved using a **prefix sum** technique. 

![LeetCode.com](/images/notes/4b53bbaf1ca1cab5b0a3959afb3ae6aaeefd5c8bf7772fb509f1d80a00ca5492.png)

**Prefix sum** technique can be used to solve problems such as:
* Find a number of arrays/matrices/tree paths that sum to a target

It's easier to understand the explanation using sum of arrays:

```swift
class Solution {
    func subarraySum(_ nums: [Int], _ k: Int) -> Int {
        var count = 0
        var sumCount: [Int: Int] = [:]
        var sum = 0
        
        for num in nums {
            sum += num
            
            // Special case if we find sum at the first position
            if sum == k {
                count += 1
            }
            
            // This is the most important part
            // Let's say we have array [10, 5, 3] and target sum 8
            // When we come to 3, the sum is 18 and 18 - target sum = 10
            // In this case we encounter sum 10 for the second time, it means that in-between we had numbers that summed up to target sum (8). 
            // Counter-intuitive but super clever
            count += sumCount[sum - k, default: 0] 
            
            sumCount[sum, default: 0] += 1
        }
        
        return count
    }
}
```

### Course Schedule

Given the number of courses and a list of prerequisites (the courses that depend on each other) determine if it's possible to create a schedule.

This task is asking to find cycles in a graph. If a cycle exists, it means the schedule cannot be formed. Perform a DFS, if we encounter a node that was already visited in the same path, the cycle exists.

### Invert Binary Tree

To invert a binary tree we need to replace the left and right nodes at each step of the tree. We can use both recursive and iterative approaches. Time and space complexity in both cases is O(n)

```swift
// If we use iterative approach, we can use queues
// O(n), O(n)
func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let root = root else { return nil }
    
    let right = invertTree(root.right)
    let left = invertTree(root.left)
    
    root.left = right
    root.right = left

    return root
}
```

### Lowest Common Ancestor of a Binary Search Tree

Because this is a binary search tree the solution can be iterative. At each point we can either go left or right depending on the p, q and root values. When p and q values are between the root, the root is our lowest common ancestor.

```swift
// O(n) O(1)
func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
    guard let p = p, let q = q else { return nil }
    
    var root = root
    
    while root != nil {
        let rootVal = root!.val
        let pVal = p.val
        let qVal = q.val
        
        if pVal > rootVal && qVal > rootVal {
            root = root!.right
        } else if pVal < rootVal && qVal < rootVal {
            root = root!.left
        } else {
            return root
        }
    }
    
    return nil
}
```

### Implement Trie (prefix tree)

This data structure is used to implement autocomplete, spell checker, IP routing, T9 predictive text, solve word games, and many more. 

Trie is a rooted tree that has:
- Maximum of X links to children (X could be for example 26, the number of lowercase letters in an English alphabet)
- A boolean field that specifies if the node is the end or not

Main functions of a trie:
1. Insert word (Time complexity O(m), Space complexity O(m)). Where m - length of the word
2. Search word (Time complexity O(m), Space complexity O(1))
3. Search prefix (Same as word, but we don't check if the last letter is the end)

Implementation:

A TrieNode. A node that holds a list of its links. We could use HashTable or Array of fixed size.
```swift
class TrieNode {
    var links: [Character: TrieNode] = [:]
    var isEnd = false
    
    func getNode(_ char: Character) -> TrieNode? {
        return links[char]
    }
    
    @discardableResult
    func createNode(_ char: Character) -> TrieNode {
        let node = TrieNode()
        links[char] = node
        return node
    }
}
```

A Trie.

To insert, we just start with the root and keep adding links.
To search, we start with the root, and look if each node has a character as a link.

```swift
class Trie {
    private var root = TrieNode()
    
    func insert(_ word: String) {
        var currentNode = root
        
        for letter in word {
            if let node = currentNode.getNode(letter) {
                currentNode = node
            } else {
                currentNode = currentNode.createNode(letter)
            }
        }
        
        currentNode.isEnd = true
    }
    
    func search(_ word: String) -> Bool {
        guard let node = findEndNode(word) else {
            return false
        }
        
        return node.isEnd
    }
    
    func startsWith(_ prefix: String) -> Bool {
        return findEndNode(prefix) != nil
    }

    // MARK: - Private
    
    private func findEndNode(_ word: String) -> TrieNode? {
        var currentNode = root
        for letter in word {
            if let node = currentNode.getNode(letter) {
                currentNode = node
            } else {
                return nil
            }
        }
        
        return currentNode
    }
}
```

### Number of Islands in a Grid

Given an m x n 2D binary grid grid which represents a map of '1's (land) and '0's (water), return the number of islands.

```swift
Input: grid = [
  ["1","1","0","0","0"],
  ["1","1","0","0","0"],
  ["0","0","1","0","0"],
  ["0","0","0","1","1"]
]
Output: 3
```

We need to look at it as a graph problem and solve either with:
1. DFS
2. BFS
3. Union Find

DFS Solution:

```swift
func numIslands(_ grid: [[Character]]) -> Int {
    var numberOfIslands = 0
    var grid = grid
    
    for row in 0..<grid.count {
        for col in 0..<grid[row].count {
            if grid[row][col] == "1" {
                markIslandAsVisited(&grid, row, col)
                numberOfIslands += 1
            }
        }
    }
    
    return numberOfIslands
}

@discardableResult
private func markIslandAsVisited(_ grid: inout [[Character]], _ row: Int, _ col: Int) {
    guard row >= 0, row < grid.count, col >= 0 , col < grid[0].count else {
        return
    }
    
    guard grid[row][col] == "1" else {
        return
    } 
    
    grid[row][col] = "0"
    
    [(row - 1, col), (row, col - 1), (row + 1, col), (row, col + 1)].forEach { newRow, newCol in 
        markIslandAsVisited(&grid, newRow, newCol)
    }
    
    return
}
```

### Combination Sum

Given array of candidates and a target sum, return a list of unique combinations of candidates that sum to target.

We use backtracking algorithm.

Time complexity - **O(N^((t/m)+1))**, where t- target value and m - minimal value.

This is from theory that the maximum number of nodes in N-ary tree of T/M height is O(N^((t/m)+1))

If 8 - target, and 2 - minimum then O(N^4+1).

Space - O(t/m)

```swift
    func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
        // unique = skip if there are 2 same numbers, leetcode already ensures it
        
        var combinations: [[Int]] = []
        
        combinationSum(candidates, target, [], &combinations)
        
        return combinations
    }
    
    private func combinationSum(_ candidates: [Int], 
                                _ remaining: Int, 
                                _ currentCombination: [Int], 
                                _ combinations: inout [[Int]]) {
        print(remaining)
        guard remaining >= 0 else { return }
        
        if remaining == 0 {
            combinations.append(currentCombination)
            return
        }
        
        for i in 0..<candidates.count {
            combinationSum(Array(candidates[i..<candidates.count]), 
                           remaining - candidates[i], 
                           currentCombination + [candidates[i]], 
                           &combinations)
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

**Dynamic Programming**
1. Look if the same problem can be split into some smaller problems in a tree structure. Then it means we can solve it using recursion. We need to know the base case to return early from recursion.
2. Make it work brute force way
3. Optimize it using “memoization” (creating dict or set for efficiency)
