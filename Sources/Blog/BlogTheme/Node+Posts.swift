//
//  Node+Posts.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Plot
import Publish

extension Node where Context == HTML.BodyContext {
    static func posts(for items: [Item<Blog>], on site: Blog) -> Node {
        return .div(
            .class("content pure-u-1 pure-u-md-3-5 pure-u-xl-6-10"),
            .div(
                .class("posts"),
                .h1(.class("content-subhead"), .text("Recent Post")),
                .forEach(items) { item in
                    .postExcerpt(for: item, on: site)
                }
            )
        )
    }
}
