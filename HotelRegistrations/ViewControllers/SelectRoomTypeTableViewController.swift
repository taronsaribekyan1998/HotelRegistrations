//
//  SelectRoomTypeTableViewController.swift
//  HotelRegistrations
//
//  Created by Taron on 02.07.22.
//

import UIKit

protocol SelectRoomTypeTableViewControllerDelegate: AnyObject {
    func didSelect(roomType: RoomType)
}

class SelectRoomTypeTableViewController: UITableViewController {
    var selectedRoomType: RoomType?
    weak var delegate: SelectRoomTypeTableViewControllerDelegate?
    
    init?(coder: NSCoder, selectedRoomType: RoomType?, delegate: SelectRoomTypeTableViewControllerDelegate?) {
        self.selectedRoomType = selectedRoomType
        self.delegate = delegate
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source and delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RoomType.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomTypeCell", for: indexPath)
        let roomType = RoomType.all[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = roomType.name
        content.secondaryText = "$ \(roomType.price)"
        cell.contentConfiguration = content
        
        if roomType == selectedRoomType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let roomType = RoomType.all[indexPath.row]
        selectedRoomType = roomType
        delegate?.didSelect(roomType: roomType)
        tableView.reloadData()
    }
}
