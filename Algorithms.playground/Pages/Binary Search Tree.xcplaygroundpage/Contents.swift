// Binary Search Tree
// https://en.wikipedia.org/wiki/Binary_search_tree
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Michael Koukoullis <http://github.com/kouky>

indirect enum Tree<T: Comparable> {
    case Node(T, Tree<T>, Tree<T>)
    case Empty
}


enum TreeError: ErrorType {
    case InvalidMinOperation
    case InvalidMaxOperation
}

extension Tree {
    func insert(x: T) -> Tree<T> {
        switch self {
        case let .Node(value, left, right) where x <= value:
            return Tree.Node(value, left.insert(x), right)
        case let .Node(value, left, right):
            return Tree.Node(value, left, right.insert(x))
        case .Empty:
            return Tree.Node(x, Tree.Empty, Tree.Empty)
        }
    }
    
    func search(x: T) -> Bool {
        switch self {
        case .Node(x, _, _):
            return true;
        case let .Node(value, left, _) where x < value:
            return left.search(x)
        case let .Node(_, _, right):
            return right.search(x)
        case .Empty:
            return false
        }
    }
    
    func min() throws -> T {
        switch self {
        case let .Node(value, Tree.Empty, _):
            return value
        case let .Node(_, left, _):
            return try! left.min()
        case .Empty:
            throw TreeError.InvalidMinOperation
        }
    }
    
    func max() throws -> T {
        switch self {
        case let .Node(value, _, Tree.Empty):
            return value
        case let .Node(_, _, right):
            return try! right.max()
        case .Empty:
            throw TreeError.InvalidMaxOperation
        }
    }
    
    func delete(x: T) -> Tree<T> {
        switch self {
        case .Node(x, Tree.Empty, Tree.Empty):
            return Tree.Empty
        case .Node(x, let left, Tree.Empty):
            return left.delete(x)
        case .Node(x, Tree.Empty, let right):
            return right.delete(x)
        case .Node(x, let left, let right):
            let successor = try! right.min()
            return Tree.Node(successor, left, right.delete(successor))
        case let .Node(value, left, right) where x <= value:
            return Tree.Node(value, left.delete(x), right)
        case let .Node(value, left, right):
            return Tree.Node(value, left, right.delete(x))
        case .Empty:
            return Tree.Empty
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

var x = Tree.Empty.insert(30).insert(20).insert(3).insert(15).insert(8)
x.invert()
x.verify()
x.search(5)
x.search(20)
x.delete(10).verify()
try x.min()
try x.max()
