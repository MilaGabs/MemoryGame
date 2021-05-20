//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Gabriel Teixeira on 12/02/21.
// Este é meu ViewModel, file que faz a ligacao, a interacao entre a view e o model
// Este funciona como um portal entre a view e o model, é como se a view conseguisse ver
// atravez deste portal o que esta acontecendo no model

// O nosso viewModel é uma class pois ele sera compartilhado com todos as views, com isso
// sera passada somente uma referencia para elas, a referencia do viewModel na pilha

import SwiftUI

// Aqui a classe acaba de atribuir o padrao observer a ela... sendo assim a view q esta vendo através dela
// sera notificada quando algo mudar... o Observable somente pode ser aplicado as classes
class EmojiMemoryGame: ObservableObject {
    // Variavel que cria o model, a mesma sera acessada por todas as views existentes na aplicacao
    // A mesma é privada pois nao queremos a view acessando diretamente e modificando direntamente o model
    // Abaixo temos uma ferramente muito util do swift que sao as funcoes embutidas (inline), nao preciso
    // declarar uma funcao para poder passa-la aqui, basta digitar a funcao dentro do proprio argumento
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    // @Published serve para toda vez q a variavel model for alterada, ele chamar o objectWillChand.send automaticamente
    // eh privado pq n queremos mais ngm alem do viewmodel criando o MemoryGame... isso n teria sentido
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["👻","🎃","🕷"]
        
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) {pairIndex in
                return emojis[pairIndex]
            }
//        MemoryGame<String>(numberOfPairsOfCards: 2, cardContentFactory: {(pairIndex: Int) -> String in
//            return "😀"
//        })
    }
    
    // MARK: - Access to the model
    // local onde as views podem "enxergar" o nosso model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intent(s)
    // funcao que permite com q as views modifiquem o model, caso ocorra alguma interacao do usuario com um dos cards 
    func choose(card: MemoryGame<String>.Card) {
      //  objectWillChange.send() // Avisa para todos q estao interessados em saber q alguma coisa mudou ou ira mudar logo logo
        model.choose(card: card)
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
