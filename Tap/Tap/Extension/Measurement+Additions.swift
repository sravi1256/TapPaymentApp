
import enum goSellSDK.Measurement

internal extension Measurement {
    
    static var allCategoriesWithDefaultUnitsOfMeasurement: [Measurement] {
        
        return [
        
            .area(.squareMeters),
            .duration(.seconds),
            .electricCharge(.ampereHours),
            .electricCurrent(.amperes),
            .energy(.joules),
            .length(.meters),
            .mass(.kilograms),
            .power(.watts),
            .volume(.cubicMeters),
            .units
        ]
    }
}
