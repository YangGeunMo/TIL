func solution(_ n:Int64) -> [Int] {
    var result:[Int] = []

    let str = String(n)
    for i in str{
        let digit = Int(String(i))!
        result.append(digit)
       
    }
    result = result.reversed()
    return result
}