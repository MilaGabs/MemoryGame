//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Gabriel Teixeira on 02/02/21.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
