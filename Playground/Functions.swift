import UIKit

func add(x: Int, y: Int) -> Int {
    return x + y
}

print(add(x: 3, y: 5))

var name : String?
name?.uppercased()
 
var myAge = "5"
var myInt = (Int(myAge) ?? 0)

if let myNum = Int(myAge) {
    print(myNum)
}
