import UIKit

var arr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
arr.append(10)
print(arr)

var mixArr = [1, 2, 3, 4, "JanFranco", 5, 6, 7] as [Any]
print(mixArr[0])
print(mixArr[4])
print(mixArr[mixArr.count - 1])

var set : Set = [1, 2, 3, 4, 5]
var arrToSet = Set(arr)
print(set.union(arrToSet))

var frequency = ["a": 1, "b":12, "c": 8]
print(frequency["a"])
print(frequency["b"])
frequency["d"] = 9
print(frequency)

