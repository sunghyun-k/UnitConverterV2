import Foundation

enum Type {
    case length
    case mass
    case volume
    case none
}

class Unit {
    var notations: [String]
    var type: Type
    /// 기준 단위로 변환하려면 이 수를 곱하십시오.
    var scaleInfo: Double
    
    init( type: Type, notations: [String], scaleInfo: Double) {
        self.type = type
        self.notations = notations
        self.scaleInfo = scaleInfo
    }
}

