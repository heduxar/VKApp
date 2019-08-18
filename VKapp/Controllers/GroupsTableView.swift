//
//  GroupsTable.swift
//  VKapp
//
//  Created by Юрий Султанов on 06.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit

class GroupsTableView: UITableViewController {
    var allGroups = [
        Group(id: 1, avatar: UIImage(named: "file"), name: "Команда ВКонтакте"),
        Group(id: 2, avatar: UIImage(named: "file"), name: "ТАСС"),
        Group(id: 3, avatar: UIImage(named: "file"), name: "Sony Pictures"),
        Group(id: 4, avatar: UIImage(named: "file"), name: "Намедни"),
        Group(id: 5, avatar: UIImage(named: "file"), name: "Телеканал История"),
        Group(id: 6, avatar: UIImage(named: "file"), name: "Topsify"),
        Group(id: 7, avatar: UIImage(named: "file"), name: "GQ Russia"),
        Group(id: 8, avatar: UIImage(named: "file"), name: "MARVEL"),
        Group(id: 9, avatar: UIImage(named: "file"), name: "MEGOGO Distribution"),
        Group(id: 10, avatar: UIImage(named: "file"), name: "Подсмотрено ВКонтакте"),
        Group(id: 11, avatar: UIImage(named: "file"), name: "#ВКосмосе"),
        Group(id: 12, avatar: UIImage(named: "file"), name: "Лекториум")
    ]
    
    @IBOutlet weak var groupSearch: UISearchBar!
    lazy var searchingText = [Group]()
    var searching = false
    let networkService = NetworkServices()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let MainTableCellNib = UINib (nibName: "MainTableCell", bundle: nil)
        tableView.register(MainTableCellNib, forCellReuseIdentifier: "MainTableCell")
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchingText.count
        } else {
            return allGroups.count
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell", for: indexPath) as? MainTableCell else { preconditionFailure("Error with Cell: MainTableCell") }
        var grps = allGroups[indexPath.row]
        if searching { grps = searchingText[indexPath.row] }
        cell.name.text = grps.name
        cell.avatar.image = grps.avatar
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addGroup", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension GroupsTableView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        networkService.searchGroups(searchText: searchText)
        searchingText = allGroups.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.tableView.reloadData()
    }
}
