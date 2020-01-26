//
//  Blog.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Foundation
import Publish
import Plot

struct Blog: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {
        var excerpt: String
    }

    var url = URL(string: "https://www.staskus.io")!
    var title = "staskus.io"
    var name = "Povilas Staškus"
    var description = "iOS Developer"
    var language: Language { .english }
    var imagePath: Path? { nil }
}
