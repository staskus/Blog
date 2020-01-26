//
//  Node+Posts.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Plot
import Publish

extension Node where Context == HTML.BodyContext {
    static func posts(for items: [Item<Blog>], on site: Blog, title: String) -> Node {
        return .pageContent(
            .div(
                .class("posts"),
                .h1(.class("content-subhead"), .text(title)),
                .forEach(items) { item in
                    .postExcerpt(for: item, on: site)
                }
            )
        )
    }
}
