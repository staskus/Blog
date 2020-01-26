---
title: "Building a real-world iOS app (Part 4): Design"
date: 2019-03-20 12:00
tags: Tutorial, iOS, Swift
excerpt: We'll see how Sketch can be used to create minimalist application screen design and app icon.
---

User experience (UX) and design is an integral part of any application. As a developer, I don't have much knowledge or "feeling" towards good looking designs. Moreover, truly great user experience requires many iterations of development and feedback. In this part we'll see how we can take example from Apple's mobile apps and design guidelines to create a familiar looking application.

# Colors

We'll begin to design by choosing the color palette of our application. One of the best ways to ensure familiarity and simplicity of the app is to have consistent colors throughout the application. I found it a great advice to limit yourself to 1 or 2 colors. 

There are a few tools online to generate color palettes so the colors would fit together nicely. 

Chosen colors should be put in a common place so it could be easily accessible.

```swift
struct Theme {
    static let primary = UIColor(red: 255/255, green: 82/255, blue: 82/255, alpha: 1.0)
    static let primaryLight = Theme.primary.withAlphaComponent(0.9)
    static let backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1.0)
}
```

# UI

Apple provides great resources for getting started. [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/) is a great starting point for understanding the thinking behind Apple's choices as well as their preferences. Users have certain expectations and habits when using any application and it's important not to distract them with an unexpected behavior. 

We'll take the inspiration from already existing _AppStore_ app. The main screen of this app has a feed that we want to display in our travel application as well. 

<img src="/images/aerogami-tutorial/part4/app_screen_example.png" alt="App Scren Example" width="300"/>

Apple also provides us with [design resources](https://developer.apple.com/design/resources/) that contain [Sketch](https://www.sketch.com) files with designs of already existing applications. When learning to sketch or design something, I found it really beneficial to have these in front of me. 

After tweaking these screens and applying our color palette we can create the first version of our design. 

<img src="/images/aerogami-tutorial/part4/app_screen_real.png" alt="Feed Screen" width="300"/>

It displays the essential information such as _origin_, _destination_, _dates_ and _price_. We can also show images which provide visual information about the destination.

# App Icon

Application icon is also a huge part of first impression of any application. We can use same given [design resources](https://developer.apple.com/design/resources/) that include examples of created app icons. 

We can use a little bit of imagination and tweak given icons on Sketch to give it a look of a travel or flight application. 

<img src="/images/aerogami-tutorial/part4/app_icon.gif" alt="Making of App Icon" width="300"/>

The resulting icon looks like this.

<img src="/images/aerogami-tutorial/part4/app_icon.png" alt="App Icon" width="300"/>

We can use [makeappicon.com](https://makeappicon.com) to generate all the necessary sizes of the icon so it could be used for different screen sizes as well as on AppStore. 

# What's next?

We saw how it's possible to create a clean design of an application without having much knowledge or spending too much time. Especially for small side projects, it's important to concentrate on main functionality and simply use best practices and examples when creating UIs. 

In the next part of the series we'll shift our attention back to the development of our application. We'll see the approach for creating new screens and keeping the view and its logic cleanly separated. 
