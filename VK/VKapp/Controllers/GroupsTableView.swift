//
//  GroupsTable.swift
//  VKapp
//
//  Created by Юрий Султанов on 06.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseFirestore

class GroupsTableView: UITableViewController {
    @IBOutlet weak var groupSearch: UISearchBar!
    var searching = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    var saved = false {
        didSet {
            let timer = DispatchTime.now() + 5
            DispatchQueue.main.asyncAfter(deadline: timer){self.saved = false}
        }
    }
    var searchingText = ""{
        didSet{
            if searchingText.count > 0{
                searchingGroups = try? Realm().objects(Group.self).filter("name CONTAINS[cd] %@", self.searchingText)
                self.tableView.reloadData()
            } else {searchingGroups = nil}
        }
    }
    let networkService = NetworkService()
    lazy var allGroups = try? Realm().objects(Group.self).filter("member != %@", 1)
    var notificationToken: NotificationToken?
    fileprivate lazy var searchingGroups = try? Realm().objects(Group.self).filter("name CONTAINS[cd] %@", searchingText)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let MainTableCellNib = UINib (nibName: "MainTableCell", bundle: nil)
        tableView.register(MainTableCellNib, forCellReuseIdentifier: "MainTableCell")
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
            case .update(_, let deletions, let insertions, let modifications):
                // Проблема с поиском при задействовании с вышестоящими условиями=(
                self.tableView.reloadData()
            case .error(let error):
                self.show(error)
            }
        }
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
}
extension GroupsTableView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        networkService.searchGroups(searchText: searchText) { [weak self] groups in
            guard let self = self else {return}
            try? RealmProvider.save(items: groups)
            self.searchingText = searchText
            let timer = DispatchTime.now() + 5
            if !self.saved{
                self.saved = true
                DispatchQueue.main.asyncAfter(deadline: timer){self.saveToFirestore(self.searchingText)}
            }
            
            self.searchingText.count > 0 ? (self.searching = true) : (self.searching = false)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
    }
    
    
    func saveToFirestore(_ request: String) {
        let firestore = Firestore.firestore()
        
        let requstToSend = request.FirestoreArray(request)
        
        
        guard let uid = Session.session.fireBaseUid else {return}
        firestore
            .collection("requests")
            .document(uid)
            .setData (requstToSend, merge: true) { [weak self] error in
                if let error = error {
                    self?.show(error)
                } else {
                    print("Data saved")
                }
        }
    }
}
