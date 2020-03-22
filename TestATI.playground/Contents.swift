import UIKit


class AtiTest {
    func example1(array: [Int]) {
        
        let crossReference1 = Dictionary(grouping: array, by: {$0})
        let duplicates1 = crossReference1.filter { $1.count > 1 }.sorted { $0.1.count > $1.1.count }
        if duplicates1.count != 0 {
            print("Значение \(duplicates1[0].key), Повторений \(duplicates1[0].value.count)")
        } else {
            print("Повторяющихся значений не найдено")
        }
    }
    
    func example2(array: [[(Int?, Int?)]]) -> [(Int, Int)] {
        var newArray2: [(Int, Int)] = []

        for i in 0...array.count-1 {
            for j in 0...array[i].count-1 {
                if let _ = array[i][j].0,
                    let _ = array[i][j].1 {
                    newArray2.append(array[i][j] as! (Int, Int))
                }
            }
        }

        newArray2.sort(by: {$0.0 < $1.0})
        print(newArray2)
        return newArray2
    }
    
    func isEqual(array: [(Int, Int)]) {
        for cort in array {
            if array[0].0 != cort.0 {
                print("false")
                return
            }
        }
        print("true")
    }
}

let array1 = [1, 5, 5, 7, 45, 23, 65, 3, 5, 35, 67, 66, 67, 12, 577, 5]

let array2: [[(Int?, Int?)]] = [[(154, 1), (123, 1), (54, 1)],
                                [(nil, 1), (75, 1), (2, 1)],
                                [(5778, 1), (nil, 1), (12, 1)],
                                [(68, 1), (83, 1), (nil, nil)]]

let testClass = AtiTest()

testClass.example1(array: array1)
let newArray = testClass.example2(array: array2)
testClass.isEqual(array: newArray)
