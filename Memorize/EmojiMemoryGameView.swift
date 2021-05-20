//
//  ContentView.swift
//  Memorize
//
//  Created by Gabriel Teixeira on 02/02/21.
// Este é nossa view, ele sempre olhara para o nosso portal viewModel
// e tambem sempre ira refletir exatamente o que esta acontecendo no nosso model
// este é responsavel por mostrar ao usuario tudo o q esta se passando pelo nosso model

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack{
            Grid(viewModel.cards) { card in
                    CardView(card: card).onTapGesture {
                        withAnimation(.linear(duration: durationAnimation)) {
                            viewModel.choose(card: card )
                        }
                    }
                    .padding(5)
                }
            
                .padding()
                .foregroundColor(.orange)
            Button(action: {
                // animacao explicita
                withAnimation(.easeInOut){
                    self.viewModel.resetGame()
                }
            }, label: { Text("New Game") })
        }
    }
    
    private let durationAnimation : Double = 0.75
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    // este eh uma variavel temporaria sincronizada com o nosso model, por isso o @state, vamos fazer uso desta pelo fato de que o nosso
    // model n nos avisa sempre q algo muda ... assim como n fica nos avisando constantemente q o tempo da nossa torta mudou
    // e isso nem é trabalho do model, para isso usamos essa variavel sincronizada com o nosso model
    @State private var animatedBonusRemaining: Double = 0
    
    private func startBonusTimeAnimation() {
        // sincronizo com o model e adiquiro quanto tempo de animacao ... de bonus ainda tenho
        animatedBonusRemaining = card.bonusRemaining
        // e logo em seguida eu digo ... imediatamente comece a descer para zero
        // de acordo com quantos segundos me restao em meu card... para q assim a animacao
        // nao acontece nem mais rapido nem mais devagar do q o tempo q me resta de bonus
        withAnimation(.linear(duration: card.bonusRemaining)) {
            animatedBonusRemaining = 0
        }
    }
    
    @ViewBuilder // usamos isso por conta q ele interpreta nossa view como uma lista, entao se meu if for falso
    // ele automaticamente retornará uma emptyView e se for verdadeiro retornará a nossa ZStack com os cards 
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animatedBonusRemaining*360-90), clockwise: true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                            }
                        // assim como visto o onAppear executa o fechamento dentro de si quando a vizualizacao acima aparece na tela
                        // todas as vezes q a view acima aparecer vou setar o tempo q falta do meu bonus, no caso sincronizar meu state com
                        // o model
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                    }
                }
                    .padding(5).opacity(0.4)
                
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 :0))
                    .animation(card.isMatched ? Animation.linear.repeatForever(autoreverses: false) : .default)
                //exemplo de uma animacao implicita
            }
            .cardify(isFaceUp: card.isFaceUp)
            //.modifier(Cardfy(isFaceUp: card.isFaceUp))
            .transition(AnyTransition.scale)
        }
    }
    
    // MARK: - Drawing Constants
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
