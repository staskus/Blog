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
        return .p(.class("post-meta"), .forEach(item.tags) { tag in
            .a(
                .class("post-category post-category-pure"),
                .href(site.path(for: tag)),
                .text(tag.string)
            )
        })
    }
}
