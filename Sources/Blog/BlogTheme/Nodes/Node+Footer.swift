//
//  Node+Footer.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Foundation
import Plot

extension Node where Context == HTML.BodyContext {
    static func footer(for site: Blog) -> Node {
        let currentYear = Calendar.current.component(.year, from: Date())
        return .div(
            .class("footer pure-u-1"),
            .div(
                .class("pure-u-1"),
                .text("© \(currentYear) \(site.name)")
            ),
            .div(
                .class("pure-u-1"),
                .text("Generated using "),
                .a(
                    .text("Publish"),
                    .href("https://github.com/johnsundell/publish")
                )
            ),
            .div(
                .class("pure-u-1"),
                .a(
                    .text("RSS feed"),
                    .href("/feed.rss")
                )
            )
        )
    }
}
