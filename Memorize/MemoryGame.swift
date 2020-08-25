import Foundation

// totaly independent - Model

// Equtable protocol uses required static func == (Self, Self) -> Bool
struct MemoryGame<CardContent> where CardContent: Equatable { // <- this struct uses generic type
    
    private(set) var games: Array<Game>
    private(set) var cards: Array<Card>
    
    // Int? Optional it's because it might be the start of a game and there's no face-up Card, or thre's two face-up Cards
    /// Btw itelegent doesn't show an error because the var get initialized to nil automatically
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        /// A little concer that we have this state (indexOfTheOneAndOnlyFaceUpCard) that I'm having to keep in sync with another state (chages to the Cards) during the game
        /// chages to the cards means isFaceUp = false for all of the cards
        /// It's kinda error-prone way to programm when we have state in two places
        /// and it's also determinable from the cards array
        /// so let's use computed this var - so if someone set this var we turn all the other cards face-down
        get {
            
            /*
            // here we need to look at all cards and see which one isFaceUp and see if there's only one
            var faceUpCardIndices = [Int]()
            for index in cards.indices {
                if cards[index].isFaceUp {
                    faceUpCardIndices.append(index)
                }
            }
            if faceUpCardIndices.count == 1 {
                return faceUpCardIndices.first // .first (element in array) is also Optional - Swift communication
            } else {
                // return here nil it's because if there's no exactly one card in the face-up card list
                // we can do this because this computed var is Int?
                return nil
            }
            */
            
            // all code above we can write in one line of code
            cards.indices.filter { cards[$0].isFaceUp }.only
            
        }
        set {
            for index in cards.indices {
                // newValue - specific var which appears inside this set only in set computed property
                /// btw newValue in this case could be nil so Index is an Int, and Int is never equal to Optional that's not set
                /// sow newValue == with Optional with assosiated integer matched - will be true
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    private var selectedGameIndex: Int? {
        get {
            games.indices.filter { games[$0].isSelected }.only
        }
        set {
            for index in games.indices {
                games[index].isSelected = index == newValue
            }
        }
    }
    
    struct Game: Identifiable {
        var isSelected: Bool = false
        var name: String
        var id: Int
    }
    
    struct Card: Identifiable {
        var isFaceUp: Bool = false
        var isMatched: Bool = false
        var content: CardContent // don't care type - type parameter
        var id: Int // for identifiable
    }
    
    // Initializer is implicitly changing ourself. Of course this is mutating.
    // We don't need to put it here because all inits are mutating
    init(numberOfGames: Int,
         gameNameFactory: (Int) -> String,
         numberOfPairsOfCards: Int,
         cardContentFactory: (Int) -> CardContent
    ) {
        games = Array<Game>()
        for gameIndex in 0..<numberOfGames {
            let name = gameNameFactory(gameIndex)
            games.append(Game(name: name, id: gameIndex))
        }
        
        cards = Array<Card>()    // creating empty array of cards
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    mutating func choose(game: Game) {
        if let selectedIndex: Int = games.firstIndex(matching: game), !self.games[selectedIndex].isSelected {
            self.games[selectedIndex].isSelected = true
            selectedGameIndex = selectedIndex
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
        if let chosenIndex: Int = cards.firstIndex(matching: card), !self.cards[chosenIndex].isFaceUp, !cards[chosenIndex].isMatched {
            // , comma means like && but first will be resolved chosenIndex and after it you can use it for the next condition
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    // but we will get and exception: Binary operator '==' cannot be applied to two 'CardContent' operands
                    /// == in Swift is not built in to the language - it's operator which assosiated with a function - so it assosiates it with the type function ==
                    /// this func takes two arguments and returns a bool, but not every type can be in those arguments
                    /// but luckily that ==  func is in a protocol called Equatable, so we can use Constrains & Gains here to dsay where our CardContent implements Equatable
                    
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchIndex].isMatched = true
                }
                self.cards[chosenIndex].isFaceUp = true
                
                // indexOfTheOneAndOnlyFaceUpCard = nil // it's already calculated in this computed var
            } else {
                /*
                // so we do not need it because we already set all the rest of face down in the computed variable
                for index in cards.indices {
                    cards[index].isFaceUp = false
                }
                */
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
            
            // self.cards[chosenIndex].isFaceUp = true // it moved above
            
            // let chosenCard: Card = self.cards[chosenIndex] /// another problem is we try to assign to copy Card out of the Array
            // chosenCard.isFaceUp = !chosenCard.isFaceUp
            /// So we have to change directly (because we could get the copy)
            // self.cards[chosenIndex].isFaceUp = !self.cards[chosenIndex].isFaceUp
            print("card chosen: \(card)")
        }
    }
}
