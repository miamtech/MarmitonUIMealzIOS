//
//  MarmitonUIMealzIOSBundle.swift
//
//
//  Created by Diarmuid McGonagle on 02/07/2024.
//

import Foundation

public struct MarmitonUIMealzIOSBundle {
    public init() {}
    
    public static var bundle: Bundle {
#if SWIFT_PACKAGE
        return Bundle.module
#else
        return Bundle.main
#endif
    }
}
