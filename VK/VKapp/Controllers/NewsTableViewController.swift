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
    var notificationToken: NotificationToken?
    private lazy var news = try? Realm().objects(News.self).sorted(byKeyPath: "date", ascending: false)
    
    var expandedCells = [IndexPath: Bool]()
    var isLoading: Bool = false
    var nextFrom: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let NewsTopCellNib = UINib (nibName: "NewsTopCell", bundle: nil)
        let NewsBottomCellNib = UINib (nibName: "NewsBottomCell", bundle: nil)
        let NewsTextCell = UINib (nibName: "NewsTextCell", bundle: nil)
        self.tableView.register(NewsTopCellNib, forCellReuseIdentifier: "NewsTopCell")
        self.tableView.register(NewsTextCell, forCellReuseIdentifier: "NewsTextCell")
        self.tableView.register(NewsBottomCellNib, forCellReuseIdentifier: "NewsBottomCell")
        let dispatchGroup = DispatchGroup()
        self.tableView.backgroundColor = .clear
        
        
        DispatchQueue.global().async(group: dispatchGroup){
            self.networkService.getNews {[weak self] result in
                guard let news = try? result.unwrap().news,
                    let groups = try? result.unwrap().groups,
                    let users = try? result.unwrap().users,
                    let timeCode = try? result.unwrap().nextFrom else {preconditionFailure("Error! GetNews-NetworkService")}
                try? RealmProvider.save(items: groups)
                try? RealmProvider.save(items: users)
                try? RealmProvider.save(items: news)
                self?.nextFrom = timeCode
            }
        }
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.tableView.reloadData()
        }
        
        tableView.allowsSelection = false
        
        refreshControl = UIRefreshControl()
//        refreshControl!.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl!.tintColor = .gray
        refreshControl!.addTarget(self, action: #selector(refreshNews(_:)), for: .valueChanged)
        
        tableView.prefetchDataSource = self
    }
    
    @objc func refreshNews(_ sender: Any){
        let lastNewsTime = news?.first?.date ?? Date().timeIntervalSince1970
        let dispatchGroup = DispatchGroup()
        var indexSet = IndexSet()
        DispatchQueue.global().async(group: dispatchGroup) {
            self.networkService.getNews(startTime: lastNewsTime) {result in
                guard let newsCounter = try? result.unwrap().news.count,
                    newsCounter > 0 else { return }
                indexSet = IndexSet(integersIn: 0..<newsCounter)
                guard let news = try? result.unwrap().news,
                    let groups = try? result.unwrap().groups,
                    let users = try? result.unwrap().users else { self.refreshControl?.endRefreshing(); return }
                try? RealmProvider.save(items: news)
                try? RealmProvider.save(items: users)
                try? RealmProvider.save(items: groups)
            }
            
        }
        dispatchGroup.notify(queue: .main){
            self.tableView.reloadData()
//MARK: TODO fix insertion 🔻
//            self.tableView.insertSections(indexSet, with: .automatic)
            self.refreshControl?.endRefreshing()
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
                //MARK: TODO - fix to insertSection⁉️
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
            cellTop.selectionStyle = .none
            return cellTop
        case 1:
            guard let cellText = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell") as? NewsTextCell else {preconditionFailure("NewsTextCell err")}
            cellText.indexPath = indexPath
            cellText.delegate = self
            cellText.configureNewsTextCell(with: news[indexPath.section])
            cellText.selectionStyle = .none
            return cellText
        case (nubmerOfRows-1):
            guard let cellBottom = tableView.dequeueReusableCell(withIdentifier: "NewsBottomCell") as? NewsBottomCell else {preconditionFailure("NewsBottomCell err")}
            cellBottom.configureNewsBottom(with: news[indexPath.section])
            cellBottom.selectionStyle = .none
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 1:
            let news = self.news?[indexPath.section]
            guard let text = news?.newsText,
                text != "" else { return 0 }
            let textSize = getLabelSize(text: text, font: UIFont.systemFont(ofSize: 14), maxWidth: tableView.bounds.width)
            let expandedState = expandedCells[indexPath] ?? false
            if expandedState {
                return UITableView.automaticDimension
            } else {
                return min(textSize.height + 20, 100)
            }
        default:
            return UITableView.automaticDimension
        }
    }
    
    private func getLabelSize(text: String, font: UIFont, maxWidth: CGFloat) -> CGSize {
        let textblock = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textblock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        let width = rect.width.rounded(.up)
        let height = rect.height.rounded(.up)
        return CGSize(width: width, height: height)
    }
}

extension NewsTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        if maxSection > news!.count - 3,
            !isLoading {
            isLoading = true
            networkService.getNews(startFrom: nextFrom) {[weak self] result in
                guard let news = try? result.unwrap().news,
                    let groups = try? result.unwrap().groups,
                    let users = try? result.unwrap().users,
                    let timeCode = try? result.unwrap().nextFrom else {preconditionFailure("Error! GetNews-NetworkService")}
                try? RealmProvider.save(items: groups)
                try? RealmProvider.save(items: users)
                try? RealmProvider.save(items: news)
                self?.nextFrom = timeCode
                self?.isLoading = false
//                self?.tableView.reloadData()
            }
        }
    }
}


extension NewsTableViewController: TextCellDelegate {
    func textCellTapped(at indexPath: IndexPath) {
        var expandedState = expandedCells[indexPath] ?? false
        expandedState.toggle()
        self.expandedCells[indexPath] = expandedState
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
