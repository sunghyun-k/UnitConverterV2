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
    
    /// 단위 정보를 저장합니다. 첫번쨰 원소는 기본적으로 표시되는 단위입니다.
    var types = [
        Type.length: [
            Unit.init(notations: ["m", "meter"], scaleInfo: 1),
            Unit.init(notations: ["cm", "centimeter"], scaleInfo: 0.01),
            Unit.init(notations: ["inch"], scaleInfo: 0.0254),
            Unit.init(notations: ["yard"], scaleInfo: 0.0277778)
        ],
        Type.mass: [
            Unit.init(notations: ["g", "gram"], scaleInfo: 1),
            Unit.init(notations: ["kg", "kilogram"], scaleInfo: 1000),
            Unit.init(notations: ["lbs", "pound", "lb"], scaleInfo: 453.592),
            Unit.init(notations: ["oz", "ounce"], scaleInfo: 28.3495)
        ],
        Type.volume: [
            Unit.init(notations: ["L", "liter", "l"], scaleInfo: 1),
            Unit.init(notations: ["pt", "pint"], scaleInfo: 0.473176),
            Unit.init(notations: ["qt", "quart"], scaleInfo: 0.946353),
            Unit.init(notations: ["gal", "galon"], scaleInfo: 4.546)
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
            var outputUnits: [String] = []
            if units[0] != "" {
                inputUnit = units[0]
            } else {
                return nil
            }
            // 출력 단위들을 outputUnit에 저장합니다.
            if units.indices.contains(1) {
                outputUnits = units[1].components(separatedBy: ",")
            }
            print("inputValue: \(inputValue), inputUnit: \(inputUnit), outputUnits: \(outputUnits)")
            return (inputValue, inputUnit, outputUnits)
        } // convertFormat의 끝
        
        func convert(_ inputValue: Double, from inputUnit: String, to outputUnits: [String]) -> [(value: Double, unit: Unit)]? {
            
            /// 기준 단위로 변환한 값과 측정 형식을 반환합니다. 호환되는 단위를 찾지 못하면 nil을 반환합니다.
            func convertToWaypoint(_ inputValue: Double, from inputUnit: String) -> (type: Type, value: Double)? {
                for type in types {
                    for unit in type.value {
                        if unit.notations.contains(inputUnit) {
                            return (type.key, inputValue * unit.scaleInfo)
                        }
                    }
                }
                return nil
            }
            
            /// 출력 단위로 변환한 값들을 반환합니다. 비어있는 경우 기준 단위를 반환합니다.
            func convertFromWaypoint(_ type: Type, _ inputValue: Double, to outputUnits: [String]) -> [(value: Double, unit: Unit)] {
                if outputUnits.isEmpty {
                    for unit in types[type]! {
                        if unit.isDefaultOutput {
                            return [(inputValue, unit)]
                        }
                    }
                }
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
            
            
            guard let waypoint = convertToWaypoint(inputValue, from: inputUnit) else {
                return nil
            }
            return convertFromWaypoint(waypoint.type, waypoint.value, to: outputUnits)
        } // convert의 끝
        
        
        guard let info = convertFormat(input) else {
            return "올바른 형식이 아닙니다."
        }
        guard let outputs = convert(info.inputValue, from: info.inputUnit, to: info.outputUnits) else {
            return "호환되는 단위가 없습니다."
        }
        
        var message = ""
        for output in outputs {
            if output.value == Double(Int(output.value)) {
                message += "결과: \(Int(output.value))\(output.unit.notations[0])\n"
            } else {
                message += "결과: \((output.value * 1000).rounded() / 1000)\(output.unit.notations[0])\n"
            }
        }
        return message
    }
    
    
}
