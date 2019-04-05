import Foundation

class UnitConverter {
    
    //MARK: 프로퍼티
    let inputValue: Double
    let inputUnit: String
    let outputUnits: [String]
    var outputValues = [Double]()
    
    init(inputValue: Double, inputUnit: String, outputUnits: [String]) {
        self.inputValue = inputValue
        self.inputUnit = inputUnit
        self.outputUnits = outputUnits
        for outputUnit in outputUnits {
            outputValues.append(convert(outputUnit: outputUnit))
            
        }
        
    }
    
    
    var type = ""
    /// 변환 메소드
    func convert(outputUnit: String) -> Double {
        
        var outputValue = inputValue
        
        func convertToCentral() {
            for type in types {
                for unit in type.value {
                    if unit.notations.contains(inputUnit) {
                        self.type = type.key
                        outputValue *= unit.scaleInfo
                        return
                    }
                }
            }
        } // toCentral 종점
        
        func convertFromCentral() {
            for unit in types[type]! {
                if unit.notations.contains(outputUnit) {
                    outputValue /= unit.scaleInfo
                    return
                }
            }
        } // fromCentral 종점
        
        convertToCentral()
        if outputValue == inputValue {
            return 0
        }
        convertFromCentral()
        
        return outputValue
    }
    
    
}

