import UIKit

class FourthViewController: UIViewController, UICalendarSelectionSingleDateDelegate, UICalendarViewDelegate {

    var selectedDateComponents: DateComponents?
    var events: [DateComponents: String] = [:]

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
        
        let eventViewController = EventViewController()
        eventViewController.delegate = self // 델리게이트 설정
        eventViewController.selectedDateComponents = dateComponents

        //컨트롤러의 크기를 조정합니다.
        eventViewController.preferredContentSize = CGSize(width: 200, height: 200)

        
        present(eventViewController, animated: true, completion: nil)
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
}

extension FourthViewController: EventViewControllerDelegate {
    func didSaveEvent(_ eventText: String) {
        guard let selectedDateComponents = selectedDateComponents else {
            print("No date selected")
            return
        }

        events[selectedDateComponents] = eventText
        calendarView.reloadDecorations(forDateComponents: [selectedDateComponents], animated: true)
        print("Event saved for date:", selectedDateComponents)
    }
}
