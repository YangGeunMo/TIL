func solution(_ n:Int64) -> Int64 {
    var str = String(n)
    
    return Int64(String(str.sorted(by: >)))!
} 