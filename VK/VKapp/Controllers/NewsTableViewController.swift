//
//  TableViewController.swift
//  VKapp
//
//  Created by Юрий Султанов on 23.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import RealmSwift

class NewsTableViewController: UITableViewController {
    let networkService = NetworkService()
    private lazy var news = try? Realm().objects(News.self).sorted(byKeyPath: "date", ascending: false)
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let NewsTopCellNib = UINib (nibName: "NewsTopCell", bundle: nil)
        let NewsBottomCellNib = UINib (nibName: "NewsBottomCell", bundle: nil)
        let NewsTextCell = UINib (nibName: "NewsTextCell", bundle: nil)
        self.tableView.register(NewsTopCellNib, forCellReuseIdentifier: "NewsTopCell")
        self.tableView.register(NewsTextCell, forCellReuseIdentifier: "NewsTextCell")
        self.tableView.register(NewsBottomCellNib, forCellReuseIdentifier: "NewsBottomCell")
        let dispatchGroup = DispatchGroup()
        DispatchQueue.global().async(group: dispatchGroup){
            self.networkService.getNews { result in
                guard let news = try? result.unwrap().news,
                    let groups = try? result.unwrap().groups,
                    let users = try? result.unwrap().users else {preconditionFailure("Error! GetNews-NetworkService")}
                try? RealmProvider.save(items: groups)
                try? RealmProvider.save(items: users)
                try? RealmProvider.save(items: news)
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationToken = news?.observe {[weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                self.tableView.reloadData()
            case .update:
                self.tableView.reloadData()
            case .error(let error):
                self.show(error)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationToken?.invalidate()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let news = news else { return 0}
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = news else {return 0}
        return news[section].numberOfRows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let news = news else {preconditionFailure("news at cellForRowAt..")}
        let nubmerOfRows = news[indexPath.section].numberOfRows
        switch indexPath.row {
        case 0:
            guard let cellTop = tableView.dequeueReusableCell(withIdentifier: "NewsTopCell") as? NewsTopCell else {preconditionFailure("NewsTopCell err")}
            cellTop.configureNewsTop(with: news[indexPath.section])
            return cellTop
        case 1:
            guard let cellText = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell") as? NewsTextCell else {preconditionFailure("NewsTextCell err")}
            cellText.configureNewsTextCell(with: news[indexPath.section])
            return cellText
        case (nubmerOfRows-1):
            guard let cellBottom = tableView.dequeueReusableCell(withIdentifier: "NewsBottomCell") as? NewsBottomCell else {preconditionFailure("NewsBottomCell err")}
            cellBottom.configureNewsBottom(with: news[indexPath.section])
            return cellBottom
        default:
            fatalError("Something wrong with cells")
        }
        //        cell.avatar = news
        //        cell.name.text = news[indexPath.row].name
        //        cell.newsText.text = news[indexPath.row].newsText
        //        if news[indexPath.row].photos.count > 0 {
        //            for image in news[indexPath.row].photos{
        //                let newView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        //                newView.contentMode = .scaleAspectFit
        //                newView.image = image
        //                newView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //                newView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //                cell.stackOfImages.addArrangedSubview(newView)
        //            }
        //            cell.stackOfImages.heightAnchor.constraint(equalToConstant: 100).isActive = true
        //        }
        //        return cell
        
    }
}
