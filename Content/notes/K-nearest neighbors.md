---
title: k-nearest neighbors
excerpt: Algorithms
---

k-nearest neighbors (KNN) algorithm is used for classification.

## Feature extraction

To classify a set of values and find k-nearest neighbors we first need to find some features (like size or color).

No matter how many features there are, we can calculate the distance by applying formula: **sqrt((a1-a2)^2 + (b1-b2)^2 + (c1-c2)^2 ... + (h1-h2)^2 )**. For a more niuanced result that takes into account how the user rates everything in general **Cosine similarity** is used to find closest neighbors.

## Classification

Categorization into a group.

## Regression

Prediction of a response.

## Examples

### Optical Character Recognition

How do understand a text from a photo? One of the ways is to use KNN algorithm and analyzes different features of the characters (curves, lines).