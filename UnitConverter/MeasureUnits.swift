import Foundation


var types = [
    "length": [
        Unit.init(type: Type.length, notations: ["centimeter"], scaleInfo: 0.01),
        Unit.init(type: Type.length, notations: ["meter"], scaleInfo: 1),
        Unit.init(type: Type.length, notations: ["inch"], scaleInfo: 0.0254),
        Unit.init(type: Type.length, notations: ["yard"], scaleInfo: 0.0277778)
    ],
    "mass": [
        Unit.init(type: Type.mass, notations: ["gram"], scaleInfo: 1),
        Unit.init(type: Type.mass, notations: ["kilogram"], scaleInfo: 1000),
        Unit.init(type: Type.mass, notations: ["pound"], scaleInfo: 453.592),
        Unit.init(type: Type.mass, notations: ["ounce"], scaleInfo: 28.349500000294)
    ],
]

