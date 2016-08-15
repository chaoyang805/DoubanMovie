//
//  String+RemoveFirstChar.swift
//  DoubanMovie
//
//  Created by chaoyang805 on 16/8/15.
//  Copyright © 2016年 jikexueyuan. All rights reserved.
//

import Foundation

extension String {
    func stringByRemoveFirstCharacter() -> String {
        guard self.characters.count >= 2 else { return "" }
        
        return self.substringFromIndex(self.startIndex.advancedBy(1))
    }
}