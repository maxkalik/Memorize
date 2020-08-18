import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    typealias ViewForItem = (Item) -> ItemView
    
    var items: [Item]
    var viewForItem: ViewForItem
    
    // escaping happened a lot more in object-oriented programming
    init(_ items: [Item], viewForItem: @escaping ViewForItem) {
        self.items = items
        // escaping means this var is going to escape this initializer without getting called
        // escaping here because it might be called later from the variable above
        self.viewForItem = viewForItem
    }
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: GridLayout(itemCount: self.items.count, in: geometry.size))
        }
    }
    
    func body(for layout: GridLayout) -> some View {
        // items - should be an array with identifiable things
        /// but the problem items: [Item] they are don't care type (generic)
        /// so here is where we get constrains and gains into the act - View where Item: Identifiable
        ForEach(items) { item in
            // self.viewForItem(item)
            self.body(for: item, in: layout)
        }
    }
    
    func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }
}
