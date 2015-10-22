// List Abstract Data Type
// https://en.wikipedia.org/wiki/List_(abstract_data_type)
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Michael Koukoullis <http://github.com/kouky>


indirect enum List<T> {
    case Node(T, List<T>)
    case Empty
    
    func add(x: T) -> List {
        switch self {
        case .Node(_, _):
            return List.Node(x, self)
        case .Empty:
            return List.Node(x, List.Empty)
        }
    }

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

enum ListError: ErrorType {
    case InvalidHeadOperation
}


var x: List<Int> = create()
var y = x.add(5).add(10).add(20).add(30)
y.print()
y.size()
y.head()
y.isEmpty()
y.tail().print()
