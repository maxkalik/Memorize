import SwiftUI

// totaly dependant - view

struct EmojiMemoryGameView: View {
    
    // Call ViewModel
    /// @ObservedObject will redraw the View every time when objectWillChange.send() be called from the ViewModel
    /// It will redraw particular element (in our case card) because SwiftUI have this ForEach method for it
    @ObservedObject var viewModel: EmojiMemoryGame
    
    // Create variables (computed) here for using in ViewBuilder
    
    var body: some View {
        // escaping closure here will be like called in the future
        /// so Swift making function type into the reference type (like classes)
        /// so it will stored in the memory where we can point in the particular time (some one tap in the future e.g.)
        /// so Functions can live in the heap and we can point to them
        /// and everything inside of this func will also will live in the heap
        /// but in our case we have a problem with self., because function itself points to self inside here
        /// so they are both can be in the heap - so we've got a situation where two thing in the heap are pointing to each other
        /// and the way that Swift cleans up memory is when nobody points to something anymore
        /// So we have got a Memory Cycle - two thing in the heap pointing to each other - it causes memory leak because memory cannot be cleaned up
        ///
        Grid(viewModel.cards) { card in
            CardView(card: card).onTapGesture {
                /// but this self. does not live in the heap because this self is this struct - structs are value type - they don't live in the heap
                /// and that is the fix that has been publicly approved
                /// so mostly in SwiftUI self. in closure it's a value types - structs, enums
                self.viewModel.choose(card: card)
            }
                .padding(5)
        }
            
            .padding()
            .foregroundColor(Color.orange)
            // This func font modifies the view
            /// The difference between declarative and imperative programming
            /// In declarative we just declare this fanc to draw this View
            /// In imperative we are calling this function to set the font at a certain moment in time
            /// In our case there is no moment in time with this declarative
            /// So any time this should draw the View that reflects the Model
            // .font(viewModel.cards.count < 5 ? Font.largeTitle : Font.body)
    }
}

// MARK: - Card View

struct CardView: View {
    var card: MemoryGame<String>.Card
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    // To avoid self in all constants, let's make a func
    func body(for size: CGSize) -> some View {
        ZStack {
            // Vars cannot be created inside a ViewBuilder
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                Text(card.content)
            } else {
                RoundedRectangle(cornerRadius: cornerRadius).fill()
            }
        }.font(Font.system(size: fontSize(for: size)))
        // .aspectRatio(3/4, contentMode: .fit)
    }
    
    // MARK: - Drawing Constants
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 3
    
    func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.75
    }
}

// MARK: - Preview Provider

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
