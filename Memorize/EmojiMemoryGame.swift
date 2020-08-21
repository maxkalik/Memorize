import SwiftUI

// ViewModel
// it's a portal between Views and Model

class EmojiMemoryGame: ObservableObject { // To make View be Reactive we have to apply this protocol
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
    /// @Published is not a swift keyword, it's a property wrapper (property var model: ..)
    /// @Published (property wrapper) adds a little functionality around a property
    /// In our case - every time this property (model) chages it calls objectWillChage.send()
    /// So in the future just add this wrapper to all properties which will chage
    ///
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    // static func will make function on the type (not the instance)
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojis = ["👻", "🎃", "🕷", "👺"]
        let numberOfPairs = emojis.count
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    // observable function (which will get from ObservableObject protocol)
    // var objectWillChange: ObservableObjectPublisher // <- we don't need it here because you can use alreay without
    
    // MARK: - Access to the Model
    
    // Safe way to do not mess up the model
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        // objectWillChange.send() // it will publish to the world
        /// but we don't need this also here because we can add @Published wrapper to property that will change
        model.choose(card: card)
    }
    
}
