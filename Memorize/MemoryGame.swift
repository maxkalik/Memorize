import Foundation

// totaly independent - Model

struct MemoryGame<CardContent> { // <- this struct uses generic type
    var cards: Array<Card>
    
    struct Card: Identifiable {
        var isFaceUp: Bool = true
        var isMatched: Bool = true
        var content: CardContent // don't care type - type parameter
        var id: Int // for identifiable
    }
    
    // Initializer is implicitly changing ourself. Of course this is mutating.
    // We don't need to put it here because all inits are mutating
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = Array<Card>()    // creating empty array of cards
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
    }
    
    // here we do not changing we just get an index, so we do not need to have mutating mark
    /*
    func index(of card: Card) -> Int {
        for index in 0..<self.cards.count {
            if self.cards[index].id == card.id {
                return index
            }
        }
        return 0 // TODO: bogus!
    }
    */
    
    // all functions which modifies self have to be mutable
    // e.g. classes are always live in the heap and can be changed
    mutating func choose(card: Card) {
        // Here we will allow the View to be Reactive
        /// It means when chages happen in the Model (here) they automatically are going to show up in the View
        /// First what we can write is like
        // card.isFaceUp = !card.isFaceUp
        /// But we will get an error that card is let and we cannot change it
        /// But the problem besides above is worse
        /// First Card is a struct - value type - it is copied every time, so here in the parameter of the func the card is already copied..
        /// So we will try to find out which card in the array cards will be updated
        // let chosenIndex: Int = self.index(of: card)
        let chosenIndex: Int = cards.firstIndex(matching: card)
        // let chosenCard: Card = self.cards[chosenIndex] /// another problem is we try to assign to copy Card out of the Array
        // chosenCard.isFaceUp = !chosenCard.isFaceUp
        /// So we have to change directly (because we could get the copy)
        self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp
        print("card chosen: \(card)")
    }
}
