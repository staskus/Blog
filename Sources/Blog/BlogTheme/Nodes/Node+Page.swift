//
//  Node+Page.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Foundation
import Plot
import Publish

extension Node where Context == HTML.BodyContext {
    static func page(for page: Page, context: PublishingContext<Blog>) -> Node {
        switch page.path.string {
            case Blog.SectionID.notes.rawValue: return .notesPage(for: page, context: context)
            default: return .defaultPage(for: page, on: context.site)
        }
        
    }

    static func defaultPage(for page: Page, on site: Blog) -> Node {
        return .pageContent(
            .h2(
                .class("post-title"),
                .text(page.title)
            ),
            .div(
                .class("post-description"),
                .div(
                    .contentBody(page.body)
                )
            )
        )
    }
}

