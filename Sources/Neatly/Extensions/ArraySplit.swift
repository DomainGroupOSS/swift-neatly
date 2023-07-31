//
//  Extensions.swift
//  Domain
//
//  Created by Aiden Benton on 10/02/2017.
//  Copyright © 2017 Fairfax Digital. All rights reserved.
//

import Foundation

internal extension Array {
    
    func split(chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map { startIndex in
            let endIndex = self.index(startIndex, offsetBy: chunkSize, limitedBy: self.count) ?? self.count
            return Array(self[startIndex ..< endIndex])
        }
    }
}
