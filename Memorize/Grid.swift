//
//  Grid.swift
//  Memorize
//
//  Created by Gabriel Teixeira on 22/02/21.
//

import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    // Essas variaveis podem ser privadas pq estamos utilizando um inicializador para elas
    // elas so teriam q ser publicas se estivessemos iniciando elas diretamente
    private var items: [Item]
    private var viewForItem: (Item) -> ItemView
    
    // usamos o @escaping nesse init pois n queremos q a funcao viewForItem seja executada nesse momento
    // entao usamos esse prefixo para ela "escapar" do init e ser executada no futuro
    // para isso acontecer o swift aloca a funcao e todas duas variaveis na pilha e acessa elas para usar posteriormente
    init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
        self.items = items
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        // usamos o geometryreader para descobrir o quanto de espaco foi alocado para nós
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    
    func body(for layout: GridLayout) -> some View {
        ForEach(items) { item in
            body(for: item, in: layout)
        }
    }
    
    func body(for item: Item, in layout: GridLayout) -> some View {
        // utilizando a extencao que criei do array
        let index = items.firstIndex(matching: item)!
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }
}
