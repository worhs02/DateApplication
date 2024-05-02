//
//  FilterDelegate.swift
//  Date_New
//
//  Created by 송재곤 on 5/2/24.
//

import UIKit

protocol FilterDelegate: AnyObject {
    func didApplyFilters(selectedKeywords: Set<String>, selectedPriceRange: String)
}
