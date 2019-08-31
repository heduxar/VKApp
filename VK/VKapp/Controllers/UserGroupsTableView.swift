//
//  UserGroupsTable.swift
//  VKapp
//
//  Created by Юрий Султанов on 06.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class UserGroupsTableView: UITableViewController {
    @IBOutlet weak var groupSearch: UISearchBar!
    lazy var searchingText = [Group]()
    var searching = false
    let networkService = NetworkService()
//    private var myGroups = [Group]()
    private lazy var myGroups = try? Realm().objects(Group.self).filter("member == %@", 1)
    
    @IBAction func addGroup (_ segue: UIStoryboardSegue) {
        guard let allGroupsVC = segue.source as? GroupsTableView,
            let indexPath = allGroupsVC.tableView.indexPathForSelectedRow else { return }
        let newGroup = allGroupsVC.allGroups[indexPath.row]
//        guard !myGroups.contains(where: { myGroups -> Bool in
//            myGroups.name == newGroup.name
//        }) else {return}
//        myGroups.append(newGroup)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let MainTableCellNib = UINib (nibName: "MainTableCell", bundle: nil)
        tableView.register(MainTableCellNib, forCellReuseIdentifier: "MainTableCell")
        networkService.getGroups(){ [weak self] groups in
            try? RealmProvider.save(items: groups)
//            self?.myGroups = groups
            self?.tableView.reloadData()
            }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            myGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching { return searchingText.count} else { return myGroups?.count ?? 0}
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell", for: indexPath) as? MainTableCell else { preconditionFailure("Error with Cell: MainTableCell") }
        var showCell = myGroups?[indexPath.row]
        if searching { showCell = searchingText[indexPath.row] }
        cell.configureGroup(with: showCell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addGroupButton", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension UserGroupsTableView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchingText = (myGroups?.filter({$0.name.lowercased().prefix(searchText.count) == searchText.lowercased()}))!
        searching = true
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        self.tableView.reloadData()
    }
}
