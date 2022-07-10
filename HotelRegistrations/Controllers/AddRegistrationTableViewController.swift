//
//  AddRegistrationTableViewController.swift
//  HotelRegistrations
//
//  Created by Taron on 29.06.22.
//

import UIKit

protocol AddRegistrationTableViewControllerDelegate: AnyObject {
    
    func didTapDoneButton(with registration: Registration)
}

final class AddRegistrationTableViewController: UITableViewController {
    
    weak var delegate: AddRegistrationTableViewControllerDelegate?
    private var selectedRoomtype: RoomType? { didSet {
        updateRoomType()
        validate()
        updateCharges()
    }
    }
    private var existingRegistration: Registration?
    private var registration: Registration? {
        guard let selectedRoomtype = selectedRoomtype else { return nil }
        
        return Registration(
            id: existingRegistration?.id ?? UUID().uuidString,
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
    
    @IBOutlet private var doneBarButton: UIBarButtonItem!
        
    @IBOutlet private var firstNameTextField: UITextField!
    @IBOutlet private var lastNameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    
    @IBOutlet private var checkInDateLabel: UILabel!
    @IBOutlet private var checkInDatePicker: UIDatePicker! { didSet {
        checkInDatePicker.minimumDate = Date()
    }}
    @IBOutlet private var checkOutDateLabel: UILabel!
    @IBOutlet private var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet private var numberOfAdultsLabel: UILabel!
    @IBOutlet private var numberOfAdultsStepper: UIStepper!
    @IBOutlet private var numberOfChildrenLabel: UILabel!
    @IBOutlet private var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet private var wifiSwitch: UISwitch!
    
    @IBOutlet private var roomTypeLabel: UILabel!
    
    @IBOutlet private var numberOfNightsLabel: UILabel!
    @IBOutlet private var checkInOutLabel: UILabel!
    @IBOutlet private var totalRoomPriceLabel: UILabel!
    @IBOutlet private var roomPricePerNightLabel: UILabel!
    @IBOutlet private var totalWiFiPriceLabel: UILabel!
    @IBOutlet private var wifiNeededLabel: UILabel!
    @IBOutlet private var totalPriceLabel: UILabel!
    
    // MARK: Initializer
    
    init?(coder: NSCoder, registration: Registration?, delegate: AddRegistrationTableViewControllerDelegate?) {
        if let registration = registration {
            existingRegistration = registration
        }
        self.delegate = delegate
        
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populate()
        updateDates()
        updateNumberOfGuests()
        updateRoomType()
        validate()
        updateCharges()
    }
    
    // MARK: Actions
    
    @IBAction private func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction private func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        if let registration = registration {
            delegate?.didTapDoneButton(with: registration)
            dismiss(animated: true)
        }
    }
    
    @IBAction private func textFieldEditingChanged() {
        validate()
    }
    
    @IBAction private func datePickerValueChanged() {
        updateDates()
        updateCharges()
    }
    
    @IBAction private func stepperValueChanged() {
        validate()
        updateNumberOfGuests()
    }
    
    @IBAction private func  wifiSwitchChanged(_ sender: UISwitch) {
        updateCharges()
    }
    
    // MARK: - Table view data source and delegate methods
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        updateRoomType()
    }
    
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
    
    private func populate() {
        if let existingRegistration = existingRegistration {
            firstNameTextField.text = existingRegistration.firstName
            lastNameTextField.text = existingRegistration.lastName
            emailTextField.text = existingRegistration.emailAddress
            checkInDatePicker.date = existingRegistration.checkInDate
            checkOutDatePicker.date = existingRegistration.checkOutDate
            numberOfAdultsStepper.value = Double(existingRegistration.numberOfAdults)
            numberOfChildrenStepper.value = Double(existingRegistration.numberOfChildren)
            wifiSwitch.isOn = existingRegistration.wifi
            selectedRoomtype = existingRegistration.roomType
        }
    }
    
    private func updateDates() {
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .hour, value: 25, to: checkInDatePicker.date)
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
    }
    
    private func updateNumberOfGuests() {
        numberOfAdultsLabel.text = String(Int(numberOfAdultsStepper.value))
        numberOfChildrenLabel.text = String(Int(numberOfChildrenStepper.value))
    }
    
    private func updateRoomType() {
        roomTypeLabel.text = selectedRoomtype?.name ?? "Not Set"
    }
    
    private func validate() {
        let isValid = !(firstNameTextField.text?.isEmpty ?? true) &&
        !(lastNameTextField.text?.isEmpty ?? true) &&
        numberOfAdultsStepper.value >= 1 &&
        selectedRoomtype != nil
        doneBarButton.isEnabled = isValid
    }
    
    private func updateCharges() {
        guard let numberOfDays = Calendar.current.dateComponents([.day], from: checkInDatePicker.date, to: checkOutDatePicker.date).day
        else { fatalError() }
        numberOfNightsLabel.text = String(numberOfDays)
        
        checkInOutLabel.text = "from " + dateFormatter.string(from: checkInDatePicker.date) + "\n" + "to " + dateFormatter.string(from: checkOutDatePicker.date)
        
        let price = (selectedRoomtype?.price ?? 0) * (numberOfDays)
        totalRoomPriceLabel.text = price == 0 ? "$ 0" : "Total $ \(price)"
        if let selectedRoom = selectedRoomtype {
            roomPricePerNightLabel.text = selectedRoom.name + "\n" + "$ \(selectedRoom.price)/night"
        } else {
            roomTypeLabel.text = nil
        }
        
        let wifiPrice = wifiSwitch.isOn ? numberOfDays * 10 : 0
        totalWiFiPriceLabel.text = "$ \(wifiPrice)"
        wifiNeededLabel.text = wifiSwitch.isOn ? "yes" : "no"
        
        totalPriceLabel.text = "$ \(price + wifiPrice)"
        
        tableView.reloadData()
    }
    
    // MARK: Segues
    
    @IBSegueAction private func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        return SelectRoomTypeTableViewController(coder: coder, selectedRoomType: selectedRoomtype, delegate: self)
    }
}

extension AddRegistrationTableViewController: SelectRoomTypeTableViewControllerDelegate {
    
    func didSelect(roomType: RoomType) {
        self.selectedRoomtype = roomType
    }
}
