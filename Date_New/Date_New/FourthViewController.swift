//
//  FourthViewController.swift
//  Date_New
//
//  Created by 이슬기 on 4/27/24.
//

import UIKit

class FourthViewController: UIViewController, UICalendarSelectionSingleDateDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        let calendarView = UICalendarView(frame: self.view.bounds)
        let greCalendar = Calendar(identifier: .gregorian)
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        calendarView.calendar = greCalendar
        calendarView.tintColor = .systemCyan
        
        self.view.addSubview(calendarView)
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        print("DATE is", dateComponents)
    }
}
