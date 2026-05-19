import Foundation

func solution(_ n:Int) -> Int
{
   guard n >= 0 && n <= 1000000000 else {return 0 }
    
    var answer:Int = 0
    var str = String(n)
    for i in str{
        let digit = Int(String(i))!
        answer = answer + digit
    }
    
    return answer
}