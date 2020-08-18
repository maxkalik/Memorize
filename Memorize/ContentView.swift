import SwiftUI

// totaly dependant - view

struct EmojiMemoryGameView: View {
    
    // Call ViewModel
    var viewModel: EmojiMemoryGame
    
    // Create variables (computed) here for using in ViewBuilder
    
    var body: some View {
        HStack {
            // Vars cannot be created inside a ViewBuilder
            ForEach(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    self.viewModel.choose(card: card)
                }
            }
        }
            .padding()
            .foregroundColor(Color.orange)
            // This func font modifies the view
            /// The difference between declarative and imperative programming
            /// In declarative we just declare this fanc to draw the this View
            /// In imperative we are calling this function to set the font at a certain moment in time
            /// In our case there is no moment in time with this declarative
            /// So any time this should draw the View that reflects the Model
            .font(
                viewModel.cards.count < 5 ? Font.largeTitle : Font.body
        )
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        }.aspectRatio(3/4, contentMode: .fit)
    }
}

// MARK: - Preview Provider

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
