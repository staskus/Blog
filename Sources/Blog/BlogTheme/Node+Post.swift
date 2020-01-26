//
//  Node+Post.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Plot
import Publish

extension Node where Context == HTML.BodyContext {
    static func post(for item: Item<Blog>, on site: Blog) -> Node {
        return .div(
            .class("content pure-u-1 pure-u-md-3-5 pure-u-xl-6-10"),
            .h2(
                .class("post-title"),
                .a(
                    .href(item.path),
                    .text(item.title)
                )
            ),
            .div(
                .class("post-description"),
                .div(
                    .contentBody(item.body)
                ),
                .tagList(for: item, on: site)
            )
        )
    }
}

