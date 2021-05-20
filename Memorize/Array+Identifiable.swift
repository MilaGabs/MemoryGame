//
//  Array+Identifiable.swift
//  Memorize
//
//  Created by Gabriel Teixeira on 25/02/21.
//

import Foundation
// criando uma extencao para o array e o deixando mais poderoso
extension Array where Element: Identifiable {
    // Utilizacao de um optional para permitir q seja retornado um valor nulo
    func firstIndex(matching: Element) -> Int? {
        
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        
        return nil
    }
}
