import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching: Element) -> Int? {
        for index in 0..<self.count {
            if self[index].id == matching.id {
                return index
            }
        }
        // return 0 it's because if the func won't find the mathced id it will return 0
        /// and 0 means the first thing in the array
        /// but the problem that the array can be an empty so we need to return an Optional Int
        // return 0
        return nil // Int? -> return nil because an array can be empty
    }
}
