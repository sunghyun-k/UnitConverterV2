import Foundation

struct Unit {
    
    var notations: [String]
    /// 이 수를 곱하면 기준 단위로 변환됩니다. 기준 단위는 1을 가집니다.
    let scaleInfo: Double
    var isDefaultOutput = false
    
    init(notations: [String], scaleInfo: Double) {
        self.notations = notations
        self.scaleInfo = scaleInfo
        if scaleInfo == 1 {
            isDefaultOutput = true
        }
    }
    
    init() {
        notations = []
        scaleInfo = 0
    }
    
}
