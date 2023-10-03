---
title: Practical Deep Learning
excerpt: AI
---

## Lesson 1

[Source - course.fast.ai](https://course.fast.ai/Lessons/lesson1.html)

To do image recognition before neural networks there was a lot of manual work involved by doing feature engineering. Neural networks are able to learn features automatically. For example, features that recognize corners, or features that recognize gradients. Going deeper into the layers, features become more complex and sophisticated. You start with a random neural network, feed it examples, and it will create features by itself.

### Myth

Deep learning requires lots of math, data, and expensive computers.

### Truth

High school math is sufficient, sometimes <50 items of data is enough to get record-breaking results, and usually you get what you need on laptop.

### Tools

[Kaggle](https://www.kaggle.com/) is community platform for data scientists. In the scope of the course, it is used to share notebooks. [Jupyter](https://jupyter.org/) is a notebook interface used for the service.

### Comparison

#### Traditional programming

**Inputs -> Program -> Results**

#### Deep learning

**Inputs + Weights -> Model -> Result**s

Model is mathematical function that takes inputs and multiplies them by one set of weights and adds them up, then it does the same with the second set of weights and adds them up again. Then it takes all the negative numbers and replaces them with zeros. And then it takes those as inputs to another layer. That is neural network.

At first weights are random so model doesn't do anything useful. Therefore, when we get the result we evaluate how correct they are and then we update the weights. We do this many times until we get the result we want. Model in the end is a very flexible function.

Once we got the trained model, then we can use it just as a regular program.

**Inputs -> Model -> Results**