import SwiftUI

// ViewModel
// it's a portal between Views and Model

class EmojiMemoryGame {
    // Why class
    /// It's easy to share
    /// one of the most cool thing about class lives in the heap and it has pointers to it
    /// All our views could have pointers to it
    /// So since you will have many of view - they will look through this "portal" (class) into the model
    
    // But it could be a problem
    /// Lots of people are pointing to the same ViewModel. They can mess it up. It ruins the party for everybody.
    /// for example we can have here a global var Model which will give an access to change something in the Whole Model
    /// it will cause messing up because we can change something we have not to change
    /// so in other words the model could be like opened door
    /// just dont forget private in some vars :)
    // private var model: MemoryGame<String> = MemoryGame<String>(numberOfPairsOfCards: 2) { _ in "😀" }
    private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    // static func will make function on the type (not the instance)
    static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["👻", "🎃", "🕷"]
        return MemoryGame<String>(numberOfPairsOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // MARK: - Access to the Model
    
    // Safe way to do not mess up the model
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
}
