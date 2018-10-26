//
//  CellHelper.swift
//  Code Bible
//
//  Created by Zaid M. Said on 09/08/2018.
//  Copyright © 2018 Zaid Said. All rights reserved.
//

import UIKit

struct CellHelper {
    let identifier: String
    let content: Any
    let height: CGFloat?

    init(identifier: String, content: Any, height: CGFloat?) {
        self.identifier = identifier
        self.content = content
        self.height = height
    }
}
