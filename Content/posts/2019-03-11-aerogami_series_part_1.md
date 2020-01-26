---
title: "Building a real-world iOS app (Part 1): Introduction"
date: 2019-03-11 12:00
tags: Tutorial, iOS, Swift
excerpt: We'll be creating and releasing an iOS application by showing a real thinking process, going through essential steps and providing the motivation behind them.
---

When learning any new technology I find it beneficial to follow a real world example. In this tutorial series we'll be creating and releasing an iOS application. The application will be created by showing a real thinking process, going through essential steps and providing the motivation behind them. Although every single line of code won't be covered, all of it will be always available on [GitHub](https://github.com/nitesuit/aerogami-ios). 

# Prerequisites

Prior knowledge of iOS development and Swift syntax is needed.

# Introduction

## Our Project

We'll be creating a flight discovery application. The users of our application should be able to:

1. See the _feed_ of _flights_
2. See the _date_, _price_, _origin_ and _destination_ of each _flight_
3. Book the _flight_. 

In the scope of this project we won't be concerned about the source of information. Our application will use mocked flight information data. However, the structure of the application will support an easy integration with any Rest API. 

## Our Approach

Throughout the series we'll cover these topics one-by-one:

1. Data Fetching and Parsing
2. Testing
3. Code Separation into Frameworks
4. Design using Sketch
5. Clean Swift Architecture
6. Building the UI and Displaying the Data
7. Release Process

## The Final Product

Here is the sneak peek of how the final product will look like. The full codebase can be found on [GitHub](https://github.com/nitesuit/aerogami-ios).

<img src="/images/aerogami-tutorial/part1/screenshot.png" alt="Application Screenshot" width="200"/>

# High Level View

Before we start, it's beneficial to understand how we're going to approach the creation of this application.

## Separation of Concerns

Essentially our application should be able to perform 3 main tasks:

1. Fetch data
2. Parse data
3. Display data

We'll separate these different concerns into frameworks for our code to be decoupled and flexible. The primitive diagram of the architecture is displayed in the picture bellow. We'll define data models and protocols in `TravelKit`. This framework will contain data fetching protocols, which will be implemented in `TravelDataKit`. DataKit, as its name suggests, will be used for fetching, persisting and providing data. User interface will only know about data models and protocols and won't be concerned about the implementation. We'll call this framework `TravelFeatureKit`. The entry point of our application will initialize the dependencies required for all the frameworks and present the root view described in `TravelFeatureKit`.

<img src="/images/aerogami-tutorial/part1/architecture.png" alt="Application Architecture" width="300"/>

In the next part of the series we'll continue by explaining how to create frameworks and setup the base of the application.
