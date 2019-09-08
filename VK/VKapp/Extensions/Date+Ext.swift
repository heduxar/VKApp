//
//  Date+Ext.swift
//  VKapp
//
//  Created by Юрий Султанов on 08.09.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

extension Date {
    func toString( dateFormat format  : String ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
