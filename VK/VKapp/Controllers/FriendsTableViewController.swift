//
//  FriendsTable.swift
//  VKapp
//
//  Created by Юрий Султанов on 05.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift
import PromiseKit


class FriendsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var lettersStackView: UIStackView!
    
    let networkService = NetworkService()
    private lazy var usernames = try? RealmProvider.get(User.self).filter("is_friend == %@", 1)
//    private lazy var usernames = try? Realm().objects(User.self).filter("is_friend == %@", 1)
    private var notificationToken: NotificationToken?
    var firstLetters =  [Character]()
    var sortedUsers: [Character: [User]] = [:]
    private let realmQ = DispatchQueue(label: "com.realmQ.heduxar", qos: .default, attributes: .concurrent)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MainTableCell.self, forCellReuseIdentifier: "MainTableCell")
        networkService.getFriends()
            .get(on: realmQ) { users in
                try? RealmProvider.save(items: users)
            }
            .done(on: .main) { users in
//                guard let users = try? Realm().objects(User.self).filter("is_friend == %@", 1) else { return }
//                try? RealmProvider.save(items: users)
//                (self.firstLetters, self.sortedUsers) = (self.sortUsers(users))
//                self.createStackView(self.firstLetters)
            }
            .catch(on: .main) { error in
                self.show(error)
            }
            .finally {
                self.tableView.reloadData()
            }
    }
        //        let dispatchGroup = DispatchGroup()
        //        DispatchQueue.global().async (group: dispatchGroup) {
        //            self.networkService.getFriends() { [weak self] users in
        //                guard let self = self else {return}
        //                try? RealmProvider.save(items: users)
        //                (self.firstLetters, self.sortedUsers) = (self.sortUsers(users))
        //                self.createStackView(self.firstLetters)
        //            }
        //        }
        //        dispatchGroup.notify(queue: DispatchQueue.main) {
        //            self.tableView.reloadData()
        //        }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationToken = usernames?.observe { [weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                self.tableView.reloadData()
            case let .update (_, deletions, insertions, modifications):
                (self.firstLetters, self.sortedUsers) = (self.sortUsers(self.usernames!))
                self.createStackView(self.firstLetters)
                self.tableView.reloadData()
            //                self.updateSections(deletions: deletions, insertions: insertions, modifications: modifications)
            case .error(let error):
                self.show(error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        notificationToken?.invalidate()
    }
    
    //MARK: - Creating StackView for Usernames
    func createStackView(_ letters: [Character]) {
        for letter in letters{
            let label = UIButton()
            label.setTitle(String(letter), for: .normal)
            label.contentHorizontalAlignment = .center
            label.contentVerticalAlignment = .center
            label.addTarget(self, action: #selector(scrollToSection), for: .touchUpInside)
            lettersStackView.addArrangedSubview(label)
        }
    }
    
    @objc private func scrollToSection(_ sender: UIButton){
        for (index, letter) in firstLetters.enumerated(){
            if let presedLetter = sender.title(for: .selected){
                if String(letter) == presedLetter {
                    tableView.scrollToRow(at: [index, 0], at: .top, animated: true)
                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImages" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                guard let usersByChar = sortedUsers[firstLetters[indexPath.section]] else { preconditionFailure("No users by letter") }
                let selectedUser = usersByChar[indexPath.row]
                if let userImagesVC = segue.destination as? UserImagesViewController{
                    userImagesVC.userId = selectedUser.id
                }
            }
        }
    }
}
extension FriendsTableViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: {_ in
            UIView.animate(withDuration: 0.05, animations: {
                self.tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform.identity
            }, completion: {_ in
                self.performSegue(withIdentifier: "showImages", sender: self)
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
        })
    }
}
extension FriendsTableViewController: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return firstLetters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let letter = firstLetters[section]
        let usersCount = sortedUsers[letter]?.count
        return usersCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableCell", for: indexPath) as? MainTableCell else { preconditionFailure("Error with Cell: MainTableCell") }
        let letter = firstLetters[indexPath.section]
        if let user = sortedUsers[letter]{
            cell.configureUser(with: user[indexPath.row])
        }
        return cell
    }
    
    //MARK: - Анимация не работает с версткой на фреймах, выбор либо анимация - либо фреймы.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? MainTableCell else {return}
        UIView.transition(with: cell, duration: 1, options: .transitionFlipFromBottom, animations: {
            //            cell.avatar.transform = CGAffineTransform (scaleX: 0.6, y: 0.6)
        }, completion: {_ in
            //            cell.avatar.transform = CGAffineTransform (scaleX: 1, y: 1)
        })
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(firstLetters[section])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 95
        return height
    }
    //MARK: SortUsers split users by surname
    /// Sort users by surname and groups them by first letter.
    ///
    /// - Parameter users: Realm results of users
    /// - Returns: Tuple (style like FirstSurnameLetter:Users)
    func sortUsers (_ users: Results<User>) -> (character: [Character], sortedUsers: [Character: [User]]){
        var characters = [Character]()
        var sortedUsers = [Character: [User]]()
        self.usernames?.forEach { user in
            guard let firstLetter = user.last_name.first else {return}
            if var letterInUsers = sortedUsers[firstLetter]{
                letterInUsers.append(user)
                sortedUsers[firstLetter] = letterInUsers
            } else {
                sortedUsers[firstLetter] = [user]
                characters.append(firstLetter)
            }
        }
        characters.sort()
        return (characters, sortedUsers)
    }
}

//extension FriendsTableViewController {
//    func updateSections(deletions: [Int], insertions: [Int], modifications: [Int]) {
//        tableView.beginUpdates()
//        tableView.deleteSections(IndexSet(deletions), with: .none)
//        tableView.insertSections(IndexSet(insertions), with: .none)
//        tableView.reloadSections(IndexSet(modifications), with: .none)
//        tableView.endUpdates()
//    }
//}
