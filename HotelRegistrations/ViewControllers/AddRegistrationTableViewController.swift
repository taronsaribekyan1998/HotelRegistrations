//
//  AddRegistrationTableViewController.swift
//  HotelRegistrations
//
//  Created by Taron on 29.06.22.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    private var selectedRoomtype: RoomType?
    private var registration: Registration? {
        guard let selectedRoomtype = selectedRoomtype else { return nil }
        
        return Registration(
            firstName: firstNameTextField.text ?? "",
            lastName: lastNameTextField.text ?? "",
            emailAddress: emailTextField.text ?? "",
            checkInDate: checkInDatePicker.date,
            checkOutDate: checkOutDatePicker.date,
            numberOfAdults: Int(numberOfAdultsStepper.value),
            numberOfChildren: Int(numberOfChildrenStepper.value),
            wifi: wifiSwitch.isOn,
            roomType: selectedRoomtype
        )
    }
    
    private let checkInDateIndexPath = IndexPath(row: 0, section: 1)
    private var isCheckInPickerVisible = false { didSet { checkInDatePicker.isHidden = !isCheckInPickerVisible} }
    private let checkOutDateIndexPath = IndexPath(row: 2, section: 1)
    private var isCheckOutPickerVisible = false { didSet { checkOutDatePicker.isHidden = !isCheckOutPickerVisible } }
    private var checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    private var checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    
    // MARK: Subviews
    
    @IBOutlet private var firstNameTextField: UITextField!
    @IBOutlet private var lastNameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    
    @IBOutlet private var checkInDateLabel: UILabel!
    @IBOutlet private var checkInDatePicker: UIDatePicker! { didSet {
        let midnight = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnight
        checkInDatePicker.date = midnight
    }}
    @IBOutlet private var checkOutDateLabel: UILabel!
    @IBOutlet private var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet private var numberOfAdultsLabel: UILabel!
    @IBOutlet private var numberOfAdultsStepper: UIStepper!
    @IBOutlet private var numberOfChildrenLabel: UILabel!
    @IBOutlet private var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet private var wifiSwitch: UISwitch!
    
    @IBOutlet private var roomTypeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateDates()
        updateRoomType()
    }
    
    // MARK: Actions
    
    @IBAction private func doneBarButtonTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction private func datePickerValueChanged() {
        updateDates()
    }
    
    @IBAction private func stepperValueChanged() {
        updateNumberOfGuests()
    }
    
    @IBAction private func  wifiSwitchChanged(_ sender: UISwitch) {
    }
    
    // MARK: - Table view data source and delegate methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerIndexPath where !isCheckInPickerVisible:
            return 0
        case checkOutDatePickerIndexPath where !isCheckOutPickerVisible:
            return 0
        default: return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == checkInDateIndexPath && !isCheckOutPickerVisible {
            isCheckInPickerVisible.toggle()
        } else if indexPath == checkOutDateIndexPath && !isCheckInPickerVisible {
            isCheckOutPickerVisible.toggle()
        } else if indexPath == checkInDateIndexPath || indexPath == checkOutDateIndexPath {
            isCheckInPickerVisible.toggle()
            isCheckOutPickerVisible.toggle()
        } else {
            return
        }
        
        tableView.reloadData()
    }
    
    // MARK: Methods
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    private func updateDates() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    private func updateNumberOfGuests() {
        numberOfAdultsLabel.text = String(Int(numberOfAdultsStepper.value))
        numberOfChildrenLabel.text = String(Int(numberOfChildrenStepper.value))
    }
    
    private func updateRoomType() {
        if let selectedRoomType = selectedRoomtype {
            roomTypeLabel.text = selectedRoomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    // MARK: Segues
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        return SelectRoomTypeTableViewController(coder: coder, selectedRoomType: selectedRoomtype, delegate: self)
    }
}

extension AddRegistrationTableViewController: SelectRoomTypeTableViewControllerDelegate {
    func didSelect(roomType: RoomType) {
        self.selectedRoomtype = roomType
        updateRoomType()
    }
}
