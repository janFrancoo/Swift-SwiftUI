import UIKit

var score = 0
var isGameOver = false

while !isGameOver {
    score += 1
    if score == 100 {
        isGameOver = true
    }
}

print(score)

for i in 1 ... 10 {
    if i % 2 == 0 && i <= 5 {
        print(i)
    }
    else {
        print(0)
    }
}
