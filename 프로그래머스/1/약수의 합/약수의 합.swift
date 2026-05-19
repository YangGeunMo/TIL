func solution(_ n:Int) -> Int {
    guard n > 0 && n <= 3000 else {return 0 }
    var result = 0
    for i in 1 ... n {
        if n % i == 0 {
            result = result + i
        }
    }
    return result
}