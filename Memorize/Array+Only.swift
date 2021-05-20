//
//  Array+Only.swift
//  Memorize
//
//  Created by Gabriel Teixeira on 02/03/21.
//

import Foundation

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
