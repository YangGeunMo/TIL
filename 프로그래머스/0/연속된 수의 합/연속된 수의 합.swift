import Foundation

func solution(_ num:Int, _ total:Int) -> [Int] {
    var result : [Int] = []
    let x = (total - num * (num - 1) / 2) / num
    for i in 0 ..< num {
        result.append(x + i)
    }
    return result
}