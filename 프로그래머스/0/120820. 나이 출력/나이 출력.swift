import Foundation

func solution(_ age:Int) -> Int {
    guard age > 0 && age <= 120 else {return 0}
    return 2022 - age + 1
}