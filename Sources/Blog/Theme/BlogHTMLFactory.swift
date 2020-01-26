//
//  BlogHTMLFactory.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Publish
import Plot

struct BlogHTMLFactory: HTMLFactory {
    func makeIndexHTML(for index: Index, context: PublishingContext<Blog>) throws -> HTML {
        HTML(
            .lang(context.site.language)
        )
    }
    
    func makeSectionHTML(for section: Section<Blog>, context: PublishingContext<Blog>) throws -> HTML {
        HTML(
            .lang(context.site.language)
        )
    }
    
    func makeItemHTML(for item: Item<Blog>, context: PublishingContext<Blog>) throws -> HTML {
        HTML(
            .lang(context.site.language)
        )
    }
    
    func makePageHTML(for page: Page, context: PublishingContext<Blog>) throws -> HTML {
        HTML(
            .lang(context.site.language)
        )
    }
    
    func makeTagListHTML(for page: TagListPage, context: PublishingContext<Blog>) throws -> HTML? {
        HTML(
            .lang(context.site.language)
        )
    }
    
    func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<Blog>) throws -> HTML? {
        HTML(
            .lang(context.site.language)
        )
    }
}
