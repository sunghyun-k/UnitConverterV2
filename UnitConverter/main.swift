import Foundation

let unitConverter = UnitConverter()

let startMessage = """
변환할 단위를 입력하십시오.
예) 10cm m,yard -> 10cm를 미터와 야드로 변환합니다.
지원되는 단위 목록: list, l
단위 추가: add, a
종료: quit, q
"""

func runUnitConverter() {
    print(startMessage)
    while true {
        let input = readLine()!
        switch input {
        case "list", "l":
            supportedUnits()
        case "add", "a":
            addUnit()
            print(startMessage)
        case "quit", "q":
            return
        default:
            print(unitConverter.convert(input))
        }
    }
}

func supportedUnits() {
    for type in unitConverter.types {
        print("\(type.key.description()):")
        for unit in type.value {
            print(unit.notations[0])
        }
        print()
    }
}


func addUnit() {
    print("""
        형식을 지정하십시오.
        길이: 1
        질량: 2
        부피: 3
        """)
    var type = Type.unknown
    while type == Type.unknown {
        let selectedType = readLine()!
        switch selectedType {
        case "1":
            type = Type.length
        case "2":
            type = Type.mass
        case "3":
            type = Type.volume
        default:
            print("오류: 형식의 숫자를 입력하세요.")
        }
    }
    
    print("이 단위의 기본 표기법을 입력하십시오.")
    var notations: [String] = []
    while true {
        let defaultNotation = readLine()!
        if defaultNotation == "" {
            print("빈 문자열을 사용할 수 없습니다. 다시 입력하십시오.")
        } else {
            notations.append(defaultNotation)
            break
        }
    }
    
    print("인식할 수 있도록 다른 표기 방법들을 입력해주십시오. 입력이 끝나면 0 입력.")
    while true {
        let notation = readLine()!
        if notation == "" {
            print("빈 문자열을 사용할 수 없습니다. 다시 입력하십시오.")
        } else if notation == "0" {
            break
        } else {
            notations.append(notation)
        }
    }
    
    // 기본 단위 찾고 저장하기
    var waypointUnit = Unit.init()
    for unit in unitConverter.types[type]! {
        if unit.isDefaultOutput == true {
            waypointUnit = unit
            break
        }
    }
    print("이 단위를 기준 단위(\(waypointUnit.notations[0]))로 변환하려면 어떤 수를 곱해야 합니까?")
    var scaleInfo = Double()
    while true {
        if let number = Double(readLine()!) {
            if number == 0 {
                print("0으로 지정할 수 없습니다. 다시 입력하십시오.")
            } else {
                scaleInfo = number
                break
            }
        } else {
            print("숫자가 아닙니다. 다시 입력하십시오.")
        }
    }
    unitConverter.add(type: type, unit: Unit.init(notations: notations, scaleInfo: scaleInfo))
    print("""
        아래 내용을 저장했습니다.
        - 유형: \(type.description())
        - 표기: \(notations)
        - 기준 단위(\(waypointUnit.notations[0]))로 변환 시에 곱해야 하는 수: \(scaleInfo)
        
        """)
} // addUnit()의 끝

runUnitConverter()
