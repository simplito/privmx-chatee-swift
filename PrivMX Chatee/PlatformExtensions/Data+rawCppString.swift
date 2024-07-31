//
//  Data+rawCppString.swift
//  PrivMX Chatee
//
//  Created by Blazej Zyglarski on 24/07/2024.
//

import Foundation
import PrivMXEndpointSwiftNative

public extension Data {
    func rawCppString() -> std.string {
        let cString = self.withUnsafeBytes { (ptr: UnsafeRawBufferPointer) -> UnsafePointer<CChar> in
            return ptr.bindMemory(to: CChar.self).baseAddress!
        }
        return std.string(cString)
    }
    
    init(from str: std.string) {
            
        self = "\(str)".data(using: .utf8) ?? Data()
        }

}
