import SwiftUI

// struct Cardify: ViewModifier {
struct Cardify: AnimatableModifier {
// struct Cardify: ViewModifier, Animatable {
    
    var rotation: Double
    var isFaceUp: Bool { rotation < 90 }
    var animatableData: Double {
        // trick - ranaming from rotation to animatableData
        get { return rotation }
        set { rotation = newValue}
    }
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    func body(content: Content) -> some View {
        ZStack {
            // Vars cannot be created inside a ViewBuilder
            /*
            if isFaceUp {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            } else {
                RoundedRectangle(cornerRadius: cornerRadius).fill()
             // .aspectRatio(3/4, contentMode: .fit)
            }
            */
            Group {
                RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
                RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
                content
            }
                .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: cornerRadius).fill()
                .opacity(isFaceUp ? 0 : 1)
            
        }
            // .rotation3DEffect(Angle.degrees(isFaceUp ? 0 : 180), axis: (0,1,0))
            .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
    }
    
    // MARK: - Drawing Constants
    
    private let cornerRadius: CGFloat = 10.0
    private let edgeLineWidth: CGFloat = 3
}

// MARK: - View Extenstion

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
