import SwiftUI

struct Grid<Item, ItemView>: View where Item: Identifiable, ItemView: View {
    typealias ViewForItem = (Item) -> ItemView
    
    private var items: [Item]
    private var viewForItem: ViewForItem
    
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
    
    private func body(for layout: GridLayout) -> some View {
        // items - should be an array with identifiable things
        /// but the problem items: [Item] they are don't care type (generic)
        /// so here is where we get constrains and gains into the act - View where Item: Identifiable
        ForEach(items) { item in
            // self.viewForItem(item)
            self.body(for: item, in: layout)
        }
    }
    
    private func body(for item: Item, in layout: GridLayout) -> some View {
        let index = items.firstIndex(matching: item)!
        
        /*
        // This case if we want return some View conditionaly
        // Group is like a ZStack and his argument { a View Builder }
        return Group {
            if index != nil {
                viewForItem(item)
                    .frame(width: layout.itemSize.width, height: layout.itemSize.height)
                    .position(layout.location(ofItemAt: index!))
            }
            // else - will return empty content
        }
        */
        
        // but we will use just index! because we are sure that array deffinetly will have items
        // if not - then something really wrong in our code above
        return viewForItem(item)
            .frame(width: layout.itemSize.width, height: layout.itemSize.height)
            .position(layout.location(ofItemAt: index))
    }
}
