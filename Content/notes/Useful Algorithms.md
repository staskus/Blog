---
title: Useful algorithms and data structures
excerpt: Algorithms
---

## The Fourier transform

- Separate a song into its frequences
- Compress songs and images
- Earthquake prediction
- DNA analysis

## Searching, inserting, deleting

- B-trees
- Red-black trees
- Heaps
- Splay trees

## Search Engines

- Inverted indexes

## Parallel algorithms

- MapReduce (Using it through Apache Hadoop)
  
## Bloom filters and HyperLogLog

They are used when fast access is needed to a large set of data and hash tables would be just too large.

- Bloom filters give a probabilistic answer but they take up very little space compared to a hash table
- HyperLogLog approximates the number of unique elements in a set. It doesn't give an exact answer but it takes only a fraction of the memory.

## The SHA algorithms

### Simhash

A locality-sensitive hash. Similar values give similar hashes. Used by Google to detect duplicates while crawling the web, it could be used to check if a student was copying an essay from the web or check for copyrighted content.

### Diffie-Hellman key exchange

Allows encrypting a message so it can only be read by the person you sent the message to.

It uses two keys: public and private. The message is encrypted by a public key but only a private key can decrypt it. 

RSA is a successor of this algorithm.

### Linear programming

Linear programming is used to maximize a result given some constraints. It uses **Simplex** algorithm. All graph problems are just a subset of linear programming. 