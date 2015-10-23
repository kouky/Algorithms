// List Abstract Data Type
// https://en.wikipedia.org/wiki/List_(abstract_data_type)
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Michael Koukoullis <http://github.com/kouky>


indirect enum List<T> {
    case Node(T, List<T>)
    case Empty
    
    func size() -> Int {
        switch self {
        case .Node(_, let tail):
            return 1 + tail.size()
        case .Empty:
            return 0
        }
    }
    
    func head() -> T {
        switch self {
        case .Node(let head, _):
            return head
        case .Empty:
            fatalError("Invalid")
        }
    }
    
    func tail() -> List {
        switch self {
        case .Node(_, let tail):
            return tail
        case .Empty:
            return List.Empty
        }
    }
    
    func isEmpty() -> Bool {
        switch self {
        case .Node:
            return false
        case .Empty:
            return true
        }
    }

    func foldl<U>(acc: U, _ f: (U, T) -> U) -> U {
        switch self {
        case let .Node(head, tail):
            return tail.foldl(f(acc, head), f)
        case .Empty:
            return acc
        }
    }
    
    func print() -> String {
        switch self {
        case let .Node(value, list):
            return "\(value)," + list.print()
        case .Empty:
            return ""
        }
    }
}

func create<T> () -> List<T> {
    return List.Empty
}

infix operator ~ { associativity right }
func ~ <T> (left: T, right: List<T>) -> List<T> {
    return List.Node(left, right)
}

// Create an empty list of Int
let x: List<Int> = create()

// Create lists of Int - these are equivalent
var z = 10 ~ 20 ~ 30 ~ 40 ~ create()
z.print()

// Head and Tail
z.head()
z.tail().print()

// Size and Empty check
z.size()
z.isEmpty()

// Fold

z.foldl(0, +)
z.foldl(1, *)
z.foldl(create()) { (acc, x) in
    return (x * 2) ~ acc
}.print()

