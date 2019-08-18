//
//  UserGroupsTable.swift
//  VKapp
//
//  Created by Юрий Султанов on 06.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class UserGroupsTableView: UITableViewController {
    var myGroups = [Group] ()
    @IBOutlet weak var groupSearch: UISearchBar!
    lazy var searchingText = [Group]()
    var searching = false
    let networkService = NetworkServices()
    @IBAction func addGroup (_ segue: UIStoryboardSegue) {
        guard let allGroupsVC = segue.source as? GroupsTableView,
            let indexPath = allGroupsVC.tableView.indexPathForSelectedRow else { return }
        let newGroup = allGroupsVC.allGroups[indexPath.row]
        guard !myGroups.contains(where: { myGroups -> Bool in
            myGroups.name == newGroup.name
        }) else {return}
        myGroups.append(newGroup)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let MainTableCellNib = UINib (nibName: "MainTableCell", bundle: nil)
        tableView.register(MainTableCellNib, forCellReuseIdentifier: "MainTableCell")
        networkService.getGroups()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGroups.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell", for: indexPath) as? MainTableCell else { preconditionFailure("Error with Cell: MainTableCell") }
        var showCell = myGroups[indexPath.row]
        if searching { showCell = searchingText[indexPath.row] }
        cell.name.text = showCell.name
        cell.avatar.image = showCell.avatar
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addGroupButton", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension UserGroupsTableView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingText = myGroups.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.tableView.reloadData()
    }
}
