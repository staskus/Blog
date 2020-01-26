//
//  Node+Header.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Plot

extension Node where Context == HTML.BodyContext {
    static func header(for site: Blog) -> Node {
        return .div(
            .div(
                .class("pure-menu pure-menu-horizontal pure-u-1-1"),
                .a(
                    .class("pure-menu-heading"),
                    .text(site.title),
                    .href(site.url)
                ),
                .ul(
                    .class("pure-menu-list"),
                    .forEach(Blog.SectionID.allCases, { section in
                        .li(
                            .class("pure-menu-item"),
                            .a(
                                .class("pure-menu-link"),
                                .text(section.rawValue.capitalized),
                                .href(site.path(for: section))
                            )
                        )
                    })
                )
            )
        )
    }
}
