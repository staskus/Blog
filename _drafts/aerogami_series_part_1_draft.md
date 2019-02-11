---
title: Creating iOS Application (Part 1)
date: 2019-02-11
categories: Tutorial
excerpt: We'll be creating and releasing an iOS application by showing a real thinking process, going through essential steps and providing the motivation behind them.
---

When learning any new technology I find it beneficial to follow a real world example. In this tutorial series we'll be creating and releasing an iOS application. The application will be created by showing a real thinking process, going through essential steps and providing the motivation behind them.

# Our Project

We'll be creating a flight discovery application. The users of our application should be able to:

1. See the _feed_ of _flights_
2. See the _date_, _price_, _origin_ and _destination_ of each _flight_
3. Book the _flight_. 

In the scope of this project we won't be concerned about the source of information. Our application will use mocked flight information data. However, the structure of the application will support an easy integration with any Rest API. 

# The Approach

Throughout the series we'll cover these topics one-by-one:

1. Data Fetching and Parsing
2. Testing
3. Code Separation into Frameworks
4. Design using Sketch
5. Clean Architecture
6. Building the UI and Displaying the Data
7. Release Process

# The Final Product

Here is the sneak peek of how the final product will look like. The full codebase can be found on [GitHub](https://github.com/nitesuit/aerogami-ios).

<img src="/assets/images/aerogami-tutorial/part1/screenshot.png" alt="Application Screenshot" width="200"/>