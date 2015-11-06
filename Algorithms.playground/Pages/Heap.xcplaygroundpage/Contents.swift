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
    private let ordering: Ordering<T>
}

enum Ordering <T: Comparable> {
    case Min
    case Max
    
    func satisfiedInvariantForParent(parent: T, child: T) -> Bool {
        switch self {
        case .Min: return parent <= child
        case .Max: return parent >= child
        }
    }
}

// Common heap operations
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
private extension Heap {
    
    func parentIndexForIndex(index: Int) -> Int? {
        guard index > 0 else {
            return nil
        }
        return (index - 1) / 2
    }
    
    func rightChildIndexForIndex(index: Int) -> Int? {
        let rightChildIndex = 2 * index + 2
        return (rightChildIndex < items.endIndex) ? rightChildIndex : nil
    }
    
    func leftChildIndexForIndex(index: Int) -> Int? {
        let leftChildIndex = 2 * index + 1
        return (leftChildIndex < items.endIndex) ? leftChildIndex : nil
    }
    
    func downHeapChildIndexForParentIndex(index: Int) -> Int? {
        switch (self.leftChildIndexForIndex(index), self.rightChildIndexForIndex(index)) {
        case (.None, .None):
            return nil
        case (.Some(let left), .None):
            return left
        case (.None, .Some(let right)):
            return right
        case (.Some(let left), .Some(let right)):
            switch ordering {
            case .Min:
                return items[left] < items[right] ? left : right
            case .Max:
                return items[left] > items[right] ? left : right
            }
        }
    }
}

// Operations to restore heap invariants
private extension Heap {
    
    func upHeap(index: Int) -> Heap {
        guard let parentIndex = self.parentIndexForIndex(index) else {
            return self
        }
        
        if ordering.satisfiedInvariantForParent(items[parentIndex], child: items[index]) {
            return self
        } else {
            return Heap(items: items.swapValuesForIndices(parentIndex, index), ordering: ordering).upHeap(parentIndex)
        }
    }
    
    func downHeap(index: Int) -> Heap {
        guard let childIndex = downHeapChildIndexForParentIndex(index) else {
            return self
        }
        
        if ordering.satisfiedInvariantForParent(items[index], child: items[childIndex]) {
            return self
        }
        else {
            return Heap(items: items.swapValuesForIndices(childIndex, index), ordering: ordering).downHeap(childIndex)
        }
    }
}

extension Heap: CustomStringConvertible {
    var description: String {
        return items.description
    }
}

private extension Array {
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
