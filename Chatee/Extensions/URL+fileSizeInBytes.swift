//
//  URL+fileSizeInBytes.swift
//  Chatee
//
//  Created by Blazej Zyglarski on 23/10/2024.
//

import Foundation
import UniformTypeIdentifiers

extension URL {
	func fileSizeInBytes() -> Int64 {
		let fileManager = FileManager.default
		do {
			let attributes = try fileManager.attributesOfItem(atPath: self.path)
			if let fileSize = attributes[FileAttributeKey.size] as? Int64 {
				return fileSize
			}
		} catch { }
			return 0
		
	}
}
