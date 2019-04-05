import Foundation

/// 입력된 문자열을 숫자와 단위로 형태를 바꿉니다. 변환하려는 단위는 `,`로 구분하여 여러개를 입력할 수 있습니다. 올바른 형식이 아니면 nil을 반환합니다.
func convertFormat(_ input: String) -> (value: Double, inputUnit: String, outputUnits: [String])? {
    
    // 숫자는 value에, 단위 문자열은 unformatedUnits에 추가합니다. 가장 첫번째로 숫자가 아닌 문자를 발견하면 추가를 멈춥니다.
    var number = ""
    var unformatedUnits = input
    for character in input {
        if ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."].contains(String(character)) {
            number += String(character)
            unformatedUnits.removeFirst()
        } else {
            break
        }
    }
    
    // 숫자가 없으면 nil을 반환합니다.
    guard let value = Double(number) else {
        return nil
    }
    
    // 단위를 inputUnit과 outputUnit으로 나눕니다. inputUnit이 없으면 nil을 반환합니다.
    let units = unformatedUnits.components(separatedBy: " ")
    var inputUnit = ""
    var outputUnit: [String] = []
    if units[0] != "" {
        inputUnit = units[0]
    } else {
        return nil
    }
    if units.indices.contains(1) {
        outputUnit = units[1].components(separatedBy: ",")
    } else {
        outputUnit.append(" ")
    }
    
    return (value, inputUnit, outputUnit)
}


/// 사용자가 조작하는 방식을 설정합니다.
func runUnitConverter() {
    
    while true {
        let input = readLine()!
        if input == "q" {
            break
        }
        
        // 형태 바꾸기에 실패하면 오류를 출력합니다.
        if let info = convertFormat(input) {
            
            let unitConverter = UnitConverter.init(inputValue: info.value, inputUnit: info.inputUnit, outputUnits: info.outputUnits)
            for index in 0..<unitConverter.outputUnits.count {
                print("결과는 \(unitConverter.outputValues[index])\(unitConverter.outputUnits[index]) 입니다.")
            }
        } else {
            print("올바른 형식이 아닙니다.")
        }
        
        
    }
}


runUnitConverter()
