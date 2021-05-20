//
//  MemoryGame.swift
//  Memorize
//
//  Created by Gabriel Teixeira on 10/02/21.
// Este file é um Model, toda a parte logica do meu codigo ficara em models como este

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    // Array q var armazenar todas as cartas presentes no jogo
    // Este por sua vez é privado para escrita permitindo somente a leitura para as "pessoas" de fora
    // pois nao queremos elas mexendo e modificando as coisas aqui dentro... para isso utilizamos o conceito de controle de acesso
    // igual ao q ja utilizamos no nosso viewModel... isso eh utilizado sempre aqui no swift
    private(set) var cards: Array<Card>
    // este tbm vai receber nosso controle de acesso pois n queremos ngm mexendo nele para n virar bagunca e nem ngm de fora olhando para ele 
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            // todo o codigo abaixo foi substituido por esta linha de codigo... gracas a extencao craida do array Array+Only
            cards.indices.filter { cards[$0].isFaceUp }.only
            
//            let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp }
            // O codigo acima substitui todo esse codigo abaixo, onde seu trabalho era inserir os indices dos cards no array de inteiros...
            // Na funcao filter utilizada acima ja é retornado altomaticamente um array para a constante
            
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    faceUpCardIndices.append(index)
//                }
//            }
//            if faceUpCardIndices.count == 1 {
//                return faceUpCardIndices.first
//            } else {
//                return nil
//            }
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    // funcao que ficara responsavel pela escolha dos cards
    // preciso usar a preposicao mutating pois estarei fazendo modificacoes no meu SELF,
    // entao necessariamente preciso avisar isso para o meu compilador
    mutating func choose(card: Card) {
        print("card choose: \(card) ")
        // utilizando a extencao que criei do array 
        if let choosenIndex: Int = cards.firstIndex(matching: card), !cards[choosenIndex].isFaceUp, !cards[choosenIndex].isMatched {
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[choosenIndex].content == cards[potentialMatchIndex].content {
                    cards[choosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                self.cards[choosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFaceUpCard = choosenIndex
            }
        }
    }
    
    // Inicializador da minha struct, aqui é recebido o numero de pares q estaram no jogo
    // e a partir disso são criadas as cartas
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
        cards.shuffle()
    }
    
    // Struct que representa uma carta
    struct Card: Identifiable {
        var isFaceUp: Bool = false {
            didSet{
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched: Bool = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        var content: CardContent
        var id: Int
        
        // MARK: - Bonus Time
    
        // This could give matchin bonus points
        // if the user matches the card
        // before a certain amount of time passes during whitch the card id face uo
        
        // can be zero whitch means "no bonus available"for this card
        var bonusTimeLimit: TimeInterval = 6
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percent of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // wheter the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // wheter we are currently face up, unmatched and have not yet used uo the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}
