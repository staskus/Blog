//
//  BlogDateFormatter.swift
//  
//
//  Created by Povilas Staskus on 1/26/20.
//

import Foundation

extension DateFormatter {
    static var blog: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
}
