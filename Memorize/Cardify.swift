//
//  Cardify.swift
//  Memorize
//
//  Created by Gabriel Teixeira on 08/03/21.
// Este file por sua vez é um Modifier, estamos herdando de ViewModifier e construindo uma struct q vai receber qualquer coisa
// e colocar nosso card envolta dessa coisa q ela esta recebendo

import SwiftUI
// O modificador usado a principio era o ViewModifier, porem como se trata de uma animacao agora
// precisamos mudar para AnimatableModifier, que nada mais é do q um viewModifier "avisando" que contem uma animacao
struct Cardify: AnimatableModifier {
    var rotation: Double
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
//            if isFaceUp {
//                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
//                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
//                content // este é o conteudo q esta sendo passado para este modifier colocar dentro do nosso card
//            } else {
//                RoundedRectangle(cornerRadius: cornerRadius).fill()
//            }
//          No codigo acima temos a forma antiga q era feito o mostrar as costas e a frente do nosso card, basicamente quando a frente existia as costas
//          deixava de existir e vise versa, porem isso era um probelma quando combinado com a animacao de girar os emojis... apenas um dos cards
//          combinados tinha o seu emoji com animacao. Para resolver isso veio o codigo abaixo, onde tanto as costa quando a frente
//          sempre vao existir na tela, e a unica coisa q mexemos nas duas é  sua opacidade
            
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content // este é o conteudo q esta sendo passado para este modifier colocar dentro do nosso card
            }
                .opacity(isFaceUp ? 1 : 0)
            
            RoundedRectangle(cornerRadius: cornerRadius).fill()
                .opacity(isFaceUp ? 0 : 1)
            
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
}

// criando uma extenção da nossa view para receber nosso cardify, para tornar possivel usar o .cardify()
extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
