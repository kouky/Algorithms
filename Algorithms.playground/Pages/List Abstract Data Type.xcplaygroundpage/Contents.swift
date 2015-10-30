// List Abstract Data Type
// https://en.wikipedia.org/wiki/List_(abstract_data_type)
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Michael Koukoullis <http://github.com/kouky>

indirect enum List<T> {
    case Cons(T, List<T>)
    case Nil
    
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
    
    func foldl<U>(start: U, _ f: (U, T) -> U) -> U {
        switch self {
        case let .Cons(head, tail):
            return tail.foldl(f(start, head), f)
        case .Nil:
            return start
        }
    }
    
    func size() -> Int {
        return self.foldl(0) { (acc, _) -> Int in
            return acc + 1
        }
    }
    
    func reverse() -> List {
        return self.foldl(List.Nil) { (acc, item) -> List in
            return List.Cons(item, acc)
        }
    }
    
    func filter(f: T -> Bool) -> List {
        let x = self.foldl(List.Nil) { (acc, item) -> List in
            if f(item) {
                return List.Cons(item, acc)
            }
            else {
                return acc
            }
        }
        return x.reverse()
    }
    
    func map<U>(f: T -> U) -> List<U> {
        let x = self.foldl(List<U>.Nil) { (acc: List<U>, item: T) -> List<U> in
            return List<U>.Cons(f(item), acc)
        }
        return x.reverse()
    }
}

extension List : CustomStringConvertible {
    var description: String {
        switch self {
        case let .Cons(value, list):
            return "\(value)," + list.description
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

// Create lists of Int
let z = 1 ~ 2 ~ 3 ~ 4 ~ 5 ~ List.Nil
z

// Create lists of tuples
let x = ("grapes", 5) ~ ("apple", 8) ~ List.Nil
x

// Head and Tail
z.head()
z.tail()

// Foldl
z.foldl(0, +)
z.foldl(1, *)
z.foldl(List.Nil) { (acc, x) in
    return (x * 2) ~ acc
}

// Functions implemeted with foldl
z.size()
z.reverse()
z.filter { (item) -> Bool in
    return item % 20 != 0
}
z.map { (item) -> Int in
    return item * 2
}
z.map { (item) -> String in
    return "$\(item).00"
}
