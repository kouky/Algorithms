// Binary Search Tree
// https://en.wikipedia.org/wiki/Binary_search_tree
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Michael Koukoullis <http://github.com/kouky>

import XCPlayground

indirect enum Tree<T: Comparable> {
    case Node(T, Tree<T>, Tree<T>)
    case Empty
    
    func insert(x: T) -> Tree<T> {
        switch self {
        case let .Node(value, left, right) where x <= value:
            return Tree.Node(value, left.insert(x), right)
        case let .Node(value, left, right) where x > value:
            return Tree.Node(value, left, right.insert(x))
        case .Empty:
            return Tree.Node(x, Tree.Empty, Tree.Empty)
        default: // Sucks we need a default
            return Tree.Node(x, Tree.Empty, Tree.Empty)
        }
    }
    
    
    func invert() -> Tree<T> {
        switch self {
        case let .Node(value, left, right):
            return Tree.Node(value, right.invert(), left.invert())
        case .Empty:
            return Tree.Empty
        }
    }
    
    
    func verify() -> Bool {
        switch self {
        case let .Node(value, left, right):
            return left.verifySmaller(value) && right.verifyLarger(value)
        case .Empty:
            return true
        }
    }
    
    func verifySmaller(parentValue: T) -> Bool {
        switch self {
        case let .Node(value, left, right):
           return value <= parentValue && left.verifySmaller(value) && right.verifyLarger(value)
        case .Empty:
            return true
        }
    }
    
    func verifyLarger(parentValue: T) -> Bool {
        switch self {
        case let .Node(value, left, right):
            return value > parentValue && left.verifySmaller(value) && right.verifyLarger(value)
        case .Empty:
            return true
        }
    }
}

var x = Tree.Empty.insert(5).insert(10).insert(3)
x.invert()
x.verify()
