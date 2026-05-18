import Foundation
func solution(_ n:Int) -> Int {
    var p = 7
    var result = 0
    if n >= p {
        if n % p == 0{
            result = (n / p)
            
        }else {
            result = (n / p) + 1
        }
    } else {
        result = 1
    }
    return result
}