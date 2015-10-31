// Heap Data Structure
// https://en.wikipedia.org/wiki/Heap_(data_structure)
// https://en.wikipedia.org/wiki/Binary_heap
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Michael Koukoullis <http://github.com/kouky>

import Darwin

// Immutable
struct Heap<T: Comparable> {
    private let items: [T]
    private let ordering: Ordering
    
}

enum Ordering {
    case Min
    case Max
}

// Public
extension Heap {
    
    // Return highest priority element (i.e. root of heap)
    func peek() -> T? {
        return items.first
    }
    
    // Add item to the heap, return the new heap
    func insert(item: T) -> Heap {
        let newHeap = Heap(items: self.items + [item], ordering: ordering)
        return newHeap.upHeap(newHeap.items.endIndex - 1)
    }
    
    // Delete the root from the heap, return the new heap
    func extract() -> Heap {
        let newHeap = Heap(items: self.moveLastItemToFront(), ordering: ordering)
        return newHeap.downHeap(0)
    }
}

// Private
extension Heap {
    
    private func upHeap(index: Int) -> Heap {
        guard let parentIndex = self.parentIndexForIndex(index) else {
            return self
        }
        
        switch ordering {
        case .Min :
            if items[parentIndex] > items[index] {
                print(self.description)
                return Heap(items: self.swapItemsForIndices(parentIndex, index), ordering: ordering).upHeap(parentIndex)
            } else {
                return self
            }
        case .Max:
            if items[parentIndex] < items[index] {
                return Heap(items: self.swapItemsForIndices(parentIndex, index), ordering: ordering).upHeap(parentIndex)
            } else {
                return self
            }
        }
    }
    
    private func downHeap(index: Int) -> Heap {
        let (leftChildIndex, rightChildIndex) = self.childIndicesForIndex(index)
        
        switch (leftChildIndex, rightChildIndex) {
        case (.None, .None):
            return self
        case (.Some(let left), .None):
            switch ordering {
            case .Min:
                if items[left] < items[index] {
                    return Heap(items: self.swapItemsForIndices(left, index), ordering: ordering).downHeap(left)
                } else {
                    return self
                }
            case .Max:
                if items[left] > items[index] {
                    return Heap(items: self.swapItemsForIndices(left, index), ordering: ordering).downHeap(left)
                } else {
                    return self
                }
            }
        case (.None, .Some(let right)):
            switch ordering {
            case .Min:
                if items[right] < items[index] {
                    return Heap(items: self.swapItemsForIndices(right, index), ordering: ordering).downHeap(right)
                } else {
                    return self
                }
            case .Max:
                if items[right] > items[index] {
                    return Heap(items: self.swapItemsForIndices(right, index), ordering: ordering).downHeap(right)
                } else {
                    return self
                }
            }
        case (.Some(let left), .Some(let right)) where items[left] < items[right]:

            switch ordering {
            case .Min:

                if items[left] < items[index] {
                    return Heap(items: self.swapItemsForIndices(left, index), ordering: ordering).downHeap(left)
                } else {
                    return self
                }
            case .Max:
                if items[right] > items[index] {
                    return Heap(items: self.swapItemsForIndices(right, index), ordering: ordering).downHeap(right)
                } else {
                    return self
                }
            }
        case (.Some(let left), .Some(let right)):
            switch ordering {
            case .Min:
                if items[right] < items[index] {
                    return Heap(items: self.swapItemsForIndices(right, index), ordering: ordering).downHeap(right)
                } else {
                    return self
                }
            case .Max:
                                print("yo \(items[left]) \(items[right])")
                if items[left] > items[index] {
                    return Heap(items: self.swapItemsForIndices(left, index), ordering: ordering).downHeap(left)
                } else {
                    return self
                }
            }
        }
    }

    private func parentIndexForIndex(index: Int) -> Int? {
        guard index > 0 else {
            return Optional.None
        }
        return (index - 1) / 2
    }
    
    private func childIndicesForIndex(index: Int) -> (Int?, Int?) {
        return (self.leftChildIndexForIndex(index), self.rightChildIndexForIndex(index))
    }
    
    private func rightChildIndexForIndex(index: Int) -> Int? {
        let rightChildIndex = 2 * index + 2
        if rightChildIndex < items.endIndex {
            return rightChildIndex
        } else {
            return nil
        }
    }
    
    private func leftChildIndexForIndex(index: Int) -> Int? {
        let leftChildIndex = 2 * index + 1
        if leftChildIndex < items.endIndex {
            return leftChildIndex
        } else {
            return nil
        }
    }

    private func swapItemsForIndices(fromIndex: Int, _ toIndex: Int) -> [T] {
        guard fromIndex >= 0 && toIndex >= 0 else {
            fatalError("Invalid indices")
        }
        var newItems = items
        newItems[fromIndex] = items[toIndex]
        newItems[toIndex] = items[fromIndex]
        return newItems
    }
    
    private func moveLastItemToFront() -> [T] {
        guard self.items.count > 1 else {
            return self.items
        }
        
        var newItems = Array(items[0..<(self.items.endIndex - 1)])
        newItems[0] = self.items[self.items.endIndex - 1]
        return newItems
    }
}

extension Heap: CustomStringConvertible {
    var description: String {
        return items.description
    }
}

let x = Heap<Int>(items: [], ordering: Ordering.Min)
// Min Heap
let emptyMinHeap = Heap<Int>(items: [], ordering: Ordering.Min)
let minHeap = emptyMinHeap.insert(10).insert(8).insert(2).insert(5).insert(7).insert(4)
minHeap.peek()
minHeap.extract()
minHeap.extract().extract()

// Max Heap
let emptyMaxHeap = Heap<Int>(items: [], ordering: Ordering.Max)
let maxHeap = emptyMaxHeap.insert(3).insert(2).insert(10).insert(4).insert(8).insert(7)
maxHeap.peek()
maxHeap.extract()
maxHeap.extract().extract()
