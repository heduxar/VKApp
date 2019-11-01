//
//  GroupsTable.swift
//  VKapp
//
//  Created by Юрий Султанов on 06.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsTableViewController: UITableViewController {
    @IBOutlet weak var groupSearch: UISearchBar!
    var searching = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var searchingText = ""{
        didSet{
            if searchingText.count > 0{
                searchingGroups = try? RealmProvider.get(Group.self).filter("name CONTAINS[cd] %@", self.searchingText)
                self.tableView.reloadData()
            } else {searchingGroups = nil}
        }
    }
    
    let networkService = NetworkService()
    lazy var allGroups = try? RealmProvider.get(Group.self).filter("member != %@", 1)
    var notificationToken: NotificationToken?
    fileprivate lazy var searchingGroups = try? RealmProvider.get(Group.self).filter("name CONTAINS[cd] %@", searchingText)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MainTableCell.self, forCellReuseIdentifier: "MainTableCell")
        networkService.getCatalog(){ groups in
            try? RealmProvider.save(items: groups)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationToken = allGroups?.observe {[weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                self.tableView.reloadData()
            case let .update (_, deletions, insertions, modifications):
                self.tableView.reloadData()
//                self.updateSections(deletions: deletions, insertions: insertions, modifications: modifications)
            case .error(let error):
                self.show(error)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationToken?.invalidate()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching { return searchingGroups?.count ?? 0} else { return allGroups?.count ?? 0}
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell", for: indexPath) as? MainTableCell else { preconditionFailure("Error with Cell: MainTableCell") }
        var groups = allGroups?[indexPath.row]
        if searching { groups = searchingGroups?[indexPath.row] }
        cell.configureGroup(with: groups)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "addGroup", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}

extension GroupsTableViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        networkService.searchGroups(searchText: searchText) { [weak self] groups in
            guard let self = self else {return}
            try? RealmProvider.save(items: groups)
            self.searchingText = searchText
            self.searchingText.count > 0 ? (self.searching = true) : (self.searching = false)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
    }
}

extension GroupsTableViewController {
    func updateSections(deletions: [Int], insertions: [Int], modifications: [Int]) {
        tableView.beginUpdates()
//        let indexP = IndexPath()
//        tableView.deleteRows(at: IndexPath[0, deletions], with: .none)
//        tableView.insertRows(at: IndexPath[0, insertions], with: .none)
//        tableView.rectForRow(at: IndexPath(0, modifications))
//        tableView.deleteSections(IndexSet(deletions), with: .none)
//        tableView.insertSections(IndexSet(insertions), with: .none)

        
//        tableView.reloadSections(IndexSet(modifications), with: .none)
        tableView.endUpdates()
    }
}
