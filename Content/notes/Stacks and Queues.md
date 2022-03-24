---
title: Stacks and Queues
excerpt: Algorithms 
---

## Stack

A stack has LIFO ordering. Main operations:

* pop() - remove the top element
* push(_) - add an item to the top
* peek() - look at the top element
* isEmpty() - true if there're no elements

### Usage
* Recursive algorithms

## Queue

A queue has FIFO ordering. Main operations:

* add(_) - aedd an item to the bottom
* remove() - remove the top element
* peek() - look at the top element
* isEmpty() - true if there're no elements

### Usage
* Breadth-first-search
* Implementing a cache

## Time complexity

* O(n) for accessing nth item
* O(1) for adding and removing an item

## Example tasks to know how to solve:

### Min Stack

A stack that also can get a minimum value. 

The trick here is to understand that minimum value only changes if the new smaller stack element is added. If this element is removed, we need to come back to an old minimum value. To achieve this we need to save a current min value with each *Node*. As it's a LIFO data structure we sort of have a timeline of minimum values. 