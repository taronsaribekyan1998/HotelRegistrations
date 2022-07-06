//
//  RegistrationsTableViewController.swift
//  HotelRegistrations
//
//  Created by Taron on 05.07.22.
//

import UIKit

class RegistrationsTableViewController: UITableViewController {
    private var registrations: [Registration] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    // MARK: - Table view data source and delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return registrations.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegistrationCell", for: indexPath)
        let registration = registrations[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = registration.firstName +  " " + registration.lastName
        content.secondaryText = (registration.checkInDate..<registration.checkOutDate).formatted(date: .numeric, time: .omitted) + ": " + registration.roomType.name
        cell.contentConfiguration = content
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch navigationItem.leftBarButtonItem?.title {
        case "Edit":
            return false
        case "Done":
            return true
        default:
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            registrations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: Segues
    
    @IBSegueAction func addEditRegistrationTableViewController(_ coder: NSCoder) -> AddRegistrationTableViewController? {
        if let indexPathForSelectedRow = tableView.indexPathForSelectedRow?.row {
            let registration = registrations[indexPathForSelectedRow]
            return AddRegistrationTableViewController(coder: coder, registration: registration, delegate: self)
        }
        return AddRegistrationTableViewController(coder: coder, registration: nil, delegate: self)
    }
}

extension RegistrationsTableViewController: AddRegistrationTableViewControllerDelegate {
    func didTapDoneButton(with registration: Registration) {
        if let index = registrations.firstIndex(of: registration) {
            registrations[index] = registration
        } else {
            registrations.append(registration)
        }
        tableView.reloadData()
    }
}
