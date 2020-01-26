//
//  Node+PostExcerpt.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Publish
import Plot

extension Node where Context == HTML.BodyContext {
    static func postExcerpt(for item: Item<Blog>, on site: Blog) -> Node {
        return .section(
            .class("post"),
            .header(
                .class("post-header"),
                .h2(
                    .class("post-title"),
                    .a(
                        .href(item.path),
                        .text(item.title)
                    )
                ),
                .p(
                    .class("post-meta"),
                    .text("By "),
                    .a(
                        .href("#"),
                        .class("post-author"),
                        .text("Tilo Mitra")
                    ),
                    .text(" under "),
                    .a(
                        .class("post-category post-category-design"),
                        .href("#"),
                        .text("CSS")
                    ),
                    .a(
                        .class("post-category post-category-pure"),
                        .href("#"),
                        .text("Pure")
                    )
                )
            ),
            .div(
                .class("post-description"),
                .p(.text(item.metadata.excerpt))
            ),
            tagList(for: item, on: site)
        )
    }
}
