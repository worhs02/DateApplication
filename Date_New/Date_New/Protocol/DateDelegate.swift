//
//  DateDelegate.swift
//  Date_New
//
//  Created by 송재곤 on 5/6/24.
//

import UIKit

protocol DateDelegate: AnyObject {
    func didSelectDate(_ date: Date,_ name: String)
}
