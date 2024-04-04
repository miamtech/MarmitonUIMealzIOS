import mealzcore

public struct MarmitonUIMealzIOS {
    public init() {}
    
    public static var bundle: Bundle {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle.main
#endif
    }
}

