// Heap Data Structure
// https://en.wikipedia.org/wiki/Heap_(data_structure)
// https://en.wikipedia.org/wiki/Binary_heap
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Michael Koukoullis <http://github.com/kouky>

import Darwin

// Full and almost full binary heaps may be represented (as an implicit data structure) using an array alone.
struct Heap<T: Comparable> {
    private let items: [T]
    private let ordering: Ordering
}

enum Ordering {
    case Min
    case Max
}

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
        let newHeap = Heap(items: items.moveLastElementToFront(), ordering: ordering)
        return newHeap.downHeap(0)
    }
}

// Implicit heap data strcuture can be navigated with index arithmentic
extension Heap {
    
    private func parentIndexForIndex(index: Int) -> Int? {
        guard index > 0 else {
            return nil
        }
        return (index - 1) / 2
    }
    
    private func rightChildIndexForIndex(index: Int) -> Int? {
        let rightChildIndex = 2 * index + 2
        return (rightChildIndex < items.endIndex) ? rightChildIndex : nil
    }
    
    private func leftChildIndexForIndex(index: Int) -> Int? {
        let leftChildIndex = 2 * index + 1
        return (leftChildIndex < items.endIndex) ? leftChildIndex : nil
    }
}

// Restore heap invariants
extension Heap {
    
    private func upHeap(index: Int) -> Heap {
        guard let parentIndex = self.parentIndexForIndex(index) else {
            return self
        }
        
        switch ordering {
        case .Min :
            if items[parentIndex] > items[index] {
                print(self.description)
                return Heap(items: items.swapValuesForIndices(parentIndex, index), ordering: ordering).upHeap(parentIndex)
            } else {
                return self
            }
        case .Max:
            if items[parentIndex] < items[index] {
                return Heap(items: items.swapValuesForIndices(parentIndex, index), ordering: ordering).upHeap(parentIndex)
            } else {
                return self
            }
        }
    }
    
    private func downHeap(index: Int) -> Heap {
        
        switch (self.leftChildIndexForIndex(index), self.rightChildIndexForIndex(index)) {
        case (.None, .None):
            return self
        case (.Some(let left), .None):
            switch ordering {
            case .Min:
                if items[left] < items[index] {
                    return Heap(items: items.swapValuesForIndices(left, index), ordering: ordering).downHeap(left)
                } else {
                    return self
                }
            case .Max:
                if items[left] > items[index] {
                    return Heap(items: items.swapValuesForIndices(left, index), ordering: ordering).downHeap(left)
                } else {
                    return self
                }
            }
        case (.None, .Some(let right)):
            switch ordering {
            case .Min:
                if items[right] < items[index] {
                    return Heap(items: items.swapValuesForIndices(right, index), ordering: ordering).downHeap(right)
                } else {
                    return self
                }
            case .Max:
                if items[right] > items[index] {
                    return Heap(items: items.swapValuesForIndices(right, index), ordering: ordering).downHeap(right)
                } else {
                    return self
                }
            }
        case (.Some(let left), .Some(let right)) where items[left] < items[right]:

            switch ordering {
            case .Min:

                if items[left] < items[index] {
                    return Heap(items: items.swapValuesForIndices(left, index), ordering: ordering).downHeap(left)
                } else {
                    return self
                }
            case .Max:
                if items[right] > items[index] {
                    return Heap(items: items.swapValuesForIndices(right, index), ordering: ordering).downHeap(right)
                } else {
                    return self
                }
            }
        case (.Some(let left), .Some(let right)):
            switch ordering {
            case .Min:
                if items[right] < items[index] {
                    return Heap(items: items.swapValuesForIndices(right, index), ordering: ordering).downHeap(right)
                } else {
                    return self
                }
            case .Max:
                if items[left] > items[index] {
                    return Heap(items: items.swapValuesForIndices(left, index), ordering: ordering).downHeap(left)
                } else {
                    return self
                }
            }
        }
    }
}

extension Heap: CustomStringConvertible {
    var description: String {
        return items.description
    }
}

extension Array {
    var lastIndex: Int {
        return self.endIndex - 1
    }
    
    var last: Element {
        return self[self.lastIndex]
    }
    
    private nonmutating func swapValuesForIndices(firstIndex: Int, _ secondIndex: Int) -> [Element] {
        guard firstIndex >= 0 && secondIndex >= 0 else {
            fatalError("Invalid indices")
        }
        var newItems = self
        newItems[firstIndex] = self[secondIndex]
        newItems[secondIndex] = self[firstIndex]
        return newItems
    }
    
    private nonmutating func moveLastElementToFront() -> [Element] {
        guard self.count > 1 else {
            return self
        }
        
        var newElements = Array(self.dropLast())
        newElements[0] = self.last
        return newElements
    }
}

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
