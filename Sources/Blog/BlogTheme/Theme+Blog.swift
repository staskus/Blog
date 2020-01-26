//
//  Theme+Blog.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Publish
import Plot

extension Theme where Site == Blog {
    static var blog: Self {
        Theme(htmlFactory: BlogHTMLFactory())
    }
}
