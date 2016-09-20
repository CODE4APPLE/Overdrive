//
//  Operation+Overdrive.swift
//  Overdrive
//
//  Created by Said Sikira on 7/7/16.
//  Copyright © 2016 Said Sikira. All rights reserved.
//

import class Foundation.Operation

extension Operation {
    open override var description: String {
        return String(describing: type(of: self))
    }
}
