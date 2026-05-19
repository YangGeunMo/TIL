import Foundation

func solution(_ slice:Int, _ n:Int) -> Int {
    var result = 0
    if n % slice  == 0 {
        result = n / slice 
        return result
    } else {
        result = (n / slice) + 1
        return result
    }
}