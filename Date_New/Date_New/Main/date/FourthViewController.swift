import UIKit
import SQLite

class FourthViewController: UIViewController, UICalendarSelectionSingleDateDelegate, UICalendarViewDelegate {
    
    var selectedDateComponents: DateComponents?
    var events: [DateComponents: String] = [:]
    var db: Connection?

    let calendarView: UICalendarView = {
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        return calendarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        calendarView.delegate = self
        let greCalendar = Calendar(identifier: .gregorian)
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        calendarView.calendar = greCalendar
        calendarView.tintColor = .systemCyan
        
        self.view.addSubview(calendarView)
        setupCalendarViewConstraints()
        
        setupDatabase()
        fetchEventsFromDatabase()
    }
    
    func setupCalendarViewConstraints() {
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            calendarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            calendarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            calendarView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selectedDateComponents = dateComponents
        guard let dateComponents = dateComponents else { return }
        
        if let eventText = events[dateComponents] {
            showEventPopup(eventText: eventText)
        } else {
            presentEventViewController(for: dateComponents)
        }
    }
    
    // MARK: - UICalendarViewDelegate
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if events[dateComponents] != nil {
            return .customView {
                let indicator = UIView()
                indicator.backgroundColor = .systemRed
                indicator.layer.cornerRadius = 4
                indicator.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    indicator.widthAnchor.constraint(equalToConstant: 8),
                    indicator.heightAnchor.constraint(equalToConstant: 8)
                ])
                return indicator
            }
        }
        return nil
    }
    
    private func setupDatabase() {
        do {
            if let bundleDBPath = Bundle.main.path(forResource: "DateAppDataBase", ofType: "db") {
                let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                let fileURL = documentDirectory.appendingPathComponent("DateAppDataBase.db")
                
                if !FileManager.default.fileExists(atPath: fileURL.path) {
                    try FileManager.default.copyItem(atPath: bundleDBPath, toPath: fileURL.path)
                }
                
                db = try Connection(fileURL.path)
            }
        } catch {
            print("Error setting up database: \(error)")
        }
    }
    
    private func fetchEventsFromDatabase() {
        guard let db = db else { return }
        
        let eventsTable = Table("event")
        let dateColumn = Expression<String>("date")
        let eventColumn = Expression<String>("event")
        
        do {
            for event in try db.prepare(eventsTable) {
                let dateString = event[dateColumn]
                let eventText = event[eventColumn]
                
                if let dateComponents = dateString.toDateComponents() {
                    events[dateComponents] = eventText
                    print("Event saved for date:", dateComponents, "Event:", eventText)
                }
            }
            calendarView.reloadDecorations(forDateComponents: Array(events.keys), animated: true)
        } catch {
            print("Error fetching events from database: \(error)")
        }
    }
    
    private func showEventPopup(eventText: String) {
        let alertController = UIAlertController(title: "Event", message: eventText, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentEventViewController(for dateComponents: DateComponents) {
        let eventViewController = EventViewController()
        eventViewController.delegate = self
        eventViewController.selectedDateComponents = dateComponents
        eventViewController.modalPresentationStyle = .popover
        if let popover = eventViewController.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        present(eventViewController, animated: true, completion: nil)
    }
}

extension FourthViewController: EventViewControllerDelegate {
    func didSaveEvent(_ eventText: String) {
        guard let selectedDateComponents = selectedDateComponents else {
            print("No date selected")
            return
        }
        
        events[selectedDateComponents] = eventText
        print("Event saved for date:", selectedDateComponents, "Event:", eventText)
        
        saveEventToDatabase(dateComponents: selectedDateComponents, eventText: eventText)
        calendarView.reloadDecorations(forDateComponents: [selectedDateComponents], animated: true)
    }
    
    private func saveEventToDatabase(dateComponents: DateComponents, eventText: String) {
        guard let db = db else { return }
        
        let eventsTable = Table("events")
        let dateColumn = Expression<String>("date")
        let eventColumn = Expression<String>("event")
        
        let dateString = dateComponents.toDateString()
        
        let insert = eventsTable.insert(dateColumn <- dateString, eventColumn <- eventText)
        do {
            try db.run(insert)
        } catch {
            print("Error saving event to database: \(error)")
        }
    }
}

extension DateComponents {
    func toDateString() -> String {
        let calendar = Calendar(identifier: .gregorian)
        if let date = calendar.date(from: self) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
        return ""
    }
}

extension String {
    func toDateComponents() -> DateComponents? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: self) {
            let calendar = Calendar(identifier: .gregorian)
            return calendar.dateComponents([.year, .month, .day], from: date)
        }
        return nil
    }
}
