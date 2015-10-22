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
        case .Node(_, let list):
            return 1 + list.size()
        case .Empty:
            return 0
        }
    }
    
    func head() -> T {
        switch self {
        case .Node(let value, _):
            return value
        case .Empty:
            fatalError("Invalid")
        }
    }
    
    func tail() -> List {
        switch self {
        case .Node(_, let list):
            return list
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
