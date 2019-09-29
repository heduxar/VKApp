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

class UserGroupsTableViewController: UITableViewController {
    @IBOutlet weak var groupSearch: UISearchBar!
    lazy var searchingText = [Group]()
    var searching = false
    let networkService = NetworkService()
    private lazy var myGroups = try? Realm().objects(Group.self).filter("member == %@", 1)
    private var notificationToken: NotificationToken?
    
    @IBAction func addGroup (_ segue: UIStoryboardSegue) {
        guard let allGroupsVC = segue.source as? GroupsTableViewController,
            let indexPath = allGroupsVC.tableView.indexPathForSelectedRow else { return }
        let newGroup = allGroupsVC.allGroups?[indexPath.row]
        let member = myGroups?.contains(where: { myGroups -> Bool in
            myGroups.name == newGroup?.name
        }) ?? false
        guard !member else {return}
        DispatchQueue.global().async {
            self.networkService.joinGroup(groupId: allGroupsVC.allGroups?[indexPath.row].id ?? 0)
            {response in
                guard let id = allGroupsVC.allGroups?[indexPath.row].id else {return}
                let group = try? Realm().objects(Group.self).filter("id == %@", id)
                try? Realm().write {
                    group?.setValue(response, forKey: "member")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let MainTableCellNib = UINib (nibName: "MainTableCell", bundle: nil)
        tableView.register(MainTableCellNib, forCellReuseIdentifier: "MainTableCell")
        DispatchQueue.global().async (flags: .barrier) {
            self.networkService.getGroups(){ groups in
                try? RealmProvider.save(items: groups)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationToken = myGroups?.observe {[weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.update(deletions: deletions, insertions: insertions, modifications: modifications)
            case .error(let error):
                self.show(error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationToken?.invalidate()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let groupId = myGroups?[indexPath.row].id else {return}
            DispatchQueue.global().async {
                self.networkService.leaveGroup(groupId: groupId){[weak self]
                    response in
                    guard let self = self,
                        let id = self.myGroups?[indexPath.row].id else {return}
                    let group = try? Realm().objects(Group.self).filter("id == %@", id)
                    if response > 0 {
                        try? Realm().write {
                            group?.setValue(0, forKey: "member")
                        }
                    }
                }
            }
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
extension UserGroupsTableViewController: UISearchBarDelegate{
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
