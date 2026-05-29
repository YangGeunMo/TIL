func solution(_ arr:[Int]) -> Double {
    var avg:Double = 0.0
    var sum:Int = 0
    for num in arr {
        sum = sum + num
    }

    avg = Double(sum) / Double(arr.count)
    return avg
}