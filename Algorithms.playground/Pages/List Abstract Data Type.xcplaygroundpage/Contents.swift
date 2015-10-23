// List Abstract Data Type
// https://en.wikipedia.org/wiki/List_(abstract_data_type)
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Michael Koukoullis <http://github.com/kouky>

indirect enum List<T> {
    case Cons(T, List<T>)
    case Nil
    
    func size() -> Int {
        switch self {
        case .Cons(_, let tail):
            return 1 + tail.size()
        case .Nil:
            return 0
        }
    }
    
    func head() -> T {
        switch self {
        case .Cons(let head, _):
            return head
        case .Nil:
            fatalError("Invalid")
        }
    }
    
    func tail() -> List {
        switch self {
        case .Cons(_, let tail):
            return tail
        case .Nil:
            return List.Nil
        }
    }
    
    func isEmpty() -> Bool {
        switch self {
        case .Cons:
            return false
        case .Nil:
            return true
        }
    }

    func foldl<U>(acc: U, _ f: (U, T) -> U) -> U {
        switch self {
        case let .Cons(head, tail):
            return tail.foldl(f(acc, head), f)
        case .Nil:
            return acc
        }
    }
    
    func print() -> String {
        switch self {
        case let .Cons(value, list):
            return "\(value)," + list.print()
        case .Nil:
            return ""
        }
    }
}

// Shorthand list construction
infix operator ~ { associativity right }
func ~ <T> (left: T, right: List<T>) -> List<T> {
    return List.Cons(left, right)
}

// Create lists of Int - these are equivalent
var z = 10 ~ 20 ~ 30 ~ 40 ~ List.Nil
z.print()

// Head and Tail
z.head()
z.tail().print()

// Size and Nil check
z.size()
z.isEmpty()

// Foldl
z.foldl(0, +)
z.foldl(1, *)
z.foldl(List.Nil) { (acc, x) in
    return (x * 2) ~ acc
}.print()

