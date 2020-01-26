//
//  Node+TagList.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func tagList(for item: Item<Blog>, on site: Blog) -> Node {
        return .div(.class("post-tags"), .forEach(item.tags) { tag in
            .a(
                .class("post-category post-category-\(tag.string.lowercased())"),
                .href(site.path(for: tag)),
                .text(tag.string)
            )
        })
    }
}
