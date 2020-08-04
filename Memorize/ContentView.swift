import SwiftUI

struct ContentView: View {
    //    var body: Text = Text("👻")
    var body: some View {
        return HStack(content: {
            ForEach(0..<4, content: { index in
                CardView(isFaceUp: false) // encapsulation
            })
        })
            .padding()
            .foregroundColor(Color.orange)
            .font(Font.largeTitle)
    }
}

// encapsulation - devide by pieces
struct CardView: View {
    
    var isFaceUp: Bool
    
    var body: some View {
        ZStack(content: {
            if isFaceUp {
                RoundedRectangle(cornerRadius: 10.0).fill(Color.white)
                RoundedRectangle(cornerRadius: 10.0).stroke(lineWidth: 3)
                Text("👻")
            } else {
                RoundedRectangle(cornerRadius: 10.0).fill()
            }
        })
    }
}

// MARK: - Preview Provider

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
