import Foundation

/// 측정 형식입니다.
enum Type {
    case length
    case mass
    case volume
    case unknown
    
    func description() -> String {
        switch self {
        case .length:
            return "길이"
        case .mass:
            return "질량"
        case .volume:
            return "부피"
        case .unknown:
            return "알 수 없음"
        }
    }
}


class UnitConverter {
    
    /// 단위 정보를 저장합니다. 출력할 단위를 입력하지 않을 시 기본으로 출력하고 싶은 단위가 있다면 빈 문자열을 배열에 추가하십시오.
    var types = [
        Type.length: [
            //TODO: type: Type.length 지우기
            Unit.init(notations: ["meter", "m"], scaleInfo: 1),
            Unit.init(notations: ["centimeter", "cm"], scaleInfo: 0.01),
            Unit.init(notations: ["inch"], scaleInfo: 0.0254),
            Unit.init(notations: ["yard"], scaleInfo: 0.0277778)
        ],
        Type.mass: [
            Unit.init(notations: ["gram", "g"], scaleInfo: 1),
            Unit.init(notations: ["kilogram", "kg"], scaleInfo: 1000),
            Unit.init(notations: ["pound", "lbs", "lb"], scaleInfo: 453.592),
            Unit.init(notations: ["ounce", "oz"], scaleInfo: 28.349500000294)
        ],
        Type.volume: [
            
        ]
    ]
    
    
    /// UnitConverter에 사용자 지정 단위를 추가합니다.
    func add(type: Type, unit: Unit) {
        types[type]?.append(unit)
    }
    
    
    
    func convert(_ input: String) -> String {
        
        /// 입력 문자열에서 숫자와 입력 단위, [출력 단위]를 반환합니다. 숫자나 입력 단위가 없으면 nil을 반환합니다.
        func convertFormat(_ input: String) -> (inputValue: Double, inputUnit: String, outputUnits: [String])? {
            // 첫번째 숫자 및 `.`를 제외한 문자가 나타나면 반복을 멈춥니다.
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
            guard let inputValue = Double(number) else {
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
            // 출력 단위들을 outputUnit에 저장합니다.
            if units.indices.contains(1) {
                outputUnit = units[1].components(separatedBy: ",")
            }
            
            return (inputValue, inputUnit, outputUnit)
        }
        
        func convert(_ inputValue: Double, from inputUnit: String, to outputUnits: [String]) -> [(outputValue: Double, outputUnit: Unit)]? {
            
            /// 기준 단위로 변환한 값과 측정 형식을 반환합니다. 호환되는 단위를 찾지 못하면 nil을 반환합니다.
            func convertToWaypoint(_ inputValue: Double, from inputUnit: String) -> (type: Type, outputValue: Double)? {
                for type in types {
                    for unit in type.value {
                        if unit.notations.contains(inputUnit) {
                            return (type.key, inputValue * unit.scaleInfo)
                        }
                    }
                }
                return nil
            }
            
            /// 출력 단위로 변환한 값들을 반환합니다. 호환되는 단위가 없다면 빈 배열을 반환합니다.
            func convertFromWaypoint(_ type: Type, _ inputValue: Double, to outputUnits: [String]) -> [(outputValue: Double, outputUnit: Unit)] {
                var outputs: [(Double, Unit)] = []
                for outputUnit in outputUnits {
                    for unit in types[type]! {
                        if unit.notations.contains(outputUnit) {
                            outputs.append((inputValue / unit.scaleInfo, unit))
                        }
                    }
                }
                return outputs
            }
            
            
            var outputs: [(outputValue: Double, outputUnit: Unit)] = []
            guard let waypoint = convertToWaypoint(inputValue, from: inputUnit) else {
                return nil
            }
            outputs = convertFromWaypoint(waypoint.type, waypoint.outputValue, to: outputUnits)
            
            return outputs
        }
        
        
        guard let info = convertFormat(input) else {
            return "올바른 형식이 아닙니다."
        }
        guard let outputs = convert(info.inputValue, from: info.inputUnit, to: info.outputUnits) else {
            return "호환되는 단위가 없습니다."
        }
        
        var message = ""
        for output in outputs {
            message += "\(output.outputValue)\(output.outputUnit.notations[0])\n"
        }
        return message
    }
    
    
}
