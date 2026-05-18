import Foundation

func solution(_ num1:Int, _ num2:Int) -> Int {
    guard (num1 > 0 && num1 <= 100) , (num2 > 0 && num2 <= 100) else {return 0}
    return num1 % num2
}