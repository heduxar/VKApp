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
    private lazy var news = try? RealmProvider.get(News.self).sorted(byKeyPath: "date", ascending: false)
    
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
        self.tableView.register(NewsImageCell.self, forCellReuseIdentifier: "NewsImageCell")
        self.tableView.register(NewsVideoCell.self, forCellReuseIdentifier: "NewsVideoCell")
        self.tableView.backgroundColor = .clear
        
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
        
        tableView.allowsSelection = false
        refreshControl = UIRefreshControl()
        refreshControl!.tintColor = .gray
        refreshControl!.addTarget(self, action: #selector(refreshNews(_:)), for: .valueChanged)
        
        tableView.prefetchDataSource = self
    }
    
    @objc func refreshNews(_ sender: Any){
        let lastNewsTime = news?.first?.date ?? Date().timeIntervalSince1970
        self.networkService.getNews(startTime: lastNewsTime) {result in
            guard let newsCounter = try? result.unwrap().news.count,
                newsCounter > 0 else { return }
            guard let news = try? result.unwrap().news,
                let groups = try? result.unwrap().groups,
                let users = try? result.unwrap().users else { self.refreshControl?.endRefreshing(); return }
            try? RealmProvider.save(items: news)
            try? RealmProvider.save(items: users)
            try? RealmProvider.save(items: groups)
        }
        self.tableView.refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationToken = news?.observe {[weak self] change in
            guard let self = self else { return }
            switch change {
            case .initial:
                self.tableView.reloadData()
            case let .update(_, deletions, insertions, modifications):
                self.updateSections(deletions: deletions, insertions: insertions, modifications: modifications)
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
        switch nubmerOfRows {
        case 2:
            switch indexPath.row {
            case 0:
                guard let cellTop = tableView.dequeueReusableCell(withIdentifier: "NewsTopCell") as? NewsTopCell else {preconditionFailure("NewsTopCell err")}
                cellTop.configureNewsTop(with: news[indexPath.section])
                cellTop.selectionStyle = .none
                return cellTop
            case (nubmerOfRows-1):
                guard let cellBottom = tableView.dequeueReusableCell(withIdentifier: "NewsBottomCell") as? NewsBottomCell else {preconditionFailure("NewsBottomCell err")}
                cellBottom.configureNewsBottom(with: news[indexPath.section])
                cellBottom.selectionStyle = .none
                return cellBottom
            default:
                fatalError()
            }
        case 3:
            switch indexPath.row {
            case 0:
                guard let cellTop = tableView.dequeueReusableCell(withIdentifier: "NewsTopCell") as? NewsTopCell else {preconditionFailure("NewsTopCell err")}
                cellTop.configureNewsTop(with: news[indexPath.section])
                cellTop.selectionStyle = .none
                return cellTop
            case 1:
                var cell = UITableViewCell()
                if news[indexPath.section].newsText != ""{
                    guard let cellText = tableView.dequeueReusableCell(withIdentifier: "NewsTextCell") as? NewsTextCell else {preconditionFailure("NewsTextCell err")}
                    cellText.indexPath = indexPath
                    cellText.delegate = self
                    cellText.configureNewsTextCell(with: news[indexPath.section])
                    cellText.selectionStyle = .none
                    cell = cellText
                } else if news[indexPath.section].photoAttachments.count > 0 ||
                    news[indexPath.section].gifUrl != ""{
                    guard let cellPhoto = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell") as? NewsImageCell else {preconditionFailure("NewsImageCell err")}
                    cellPhoto.configureImageCell(with: news[indexPath.section])
                    cellPhoto.selectionStyle = .none
                    cell = cellPhoto
                } else if news[indexPath.section].videoAttachments.count > 0 {
                    guard let cellVideo = tableView.dequeueReusableCell(withIdentifier: "NewsVideoCell") as? NewsVideoCell else {preconditionFailure("NewsVideoCell err")}
                    cellVideo.configureVideoCell(with: news[indexPath.section])
                    cellVideo.selectionStyle = .none
                    cell = cellVideo
                }
                return cell
            case (nubmerOfRows-1):
                guard let cellBottom = tableView.dequeueReusableCell(withIdentifier: "NewsBottomCell") as? NewsBottomCell else {preconditionFailure("NewsBottomCell err")}
                cellBottom.configureNewsBottom(with: news[indexPath.section])
                cellBottom.selectionStyle = .none
                return cellBottom
            default:
                fatalError("Something wrong with cells")
            }
        case 4:
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
            case 2:
                var cell = UITableViewCell()
                if news[indexPath.section].photoAttachments.count > 0 ||
                    news[indexPath.section].gifUrl != "" {
                    guard let cellPhoto = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell") as? NewsImageCell else {preconditionFailure("NewsImageCell err")}
                    cellPhoto.configureImageCell(with: news[indexPath.section])
                    cellPhoto.selectionStyle = .none
                    cell = cellPhoto
                } else if news[indexPath.section].videoAttachments.count > 0{
                    guard let cellVideo = tableView.dequeueReusableCell(withIdentifier: "NewsVideoCell") as? NewsVideoCell else {preconditionFailure("NewsVideoCell err")}
                    cellVideo.configureVideoCell(with: news[indexPath.section])
                    cellVideo.selectionStyle = .none
                    cell = cellVideo
                }
                return cell
            case (nubmerOfRows-1):
                guard let cellBottom = tableView.dequeueReusableCell(withIdentifier: "NewsBottomCell") as? NewsBottomCell else {preconditionFailure("NewsBottomCell err")}
                cellBottom.configureNewsBottom(with: news[indexPath.section])
                cellBottom.selectionStyle = .none
                return cellBottom
            default:
                fatalError("Something wrong with cells")
            }
        default:
            fatalError("Something wrong news.numberOfRows")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let news = self.news?[indexPath.section] else {return UITableView.automaticDimension}
        switch news.numberOfRows {
        case 3:
            switch indexPath.row {
            case 1:
                if news.newsText != "" {
                    let text = news.newsText
                    let textSize = getLabelSize(text: text, font: UIFont.systemFont(ofSize: 14), maxWidth: tableView.bounds.width)
                    let expandedState = expandedCells[indexPath] ?? false
                    if expandedState {
                        return UITableView.automaticDimension
                    } else {
                        return min(textSize.height + 20, 100)
                    }
                } else if news.photoAttachments.count > 0 {
                    guard let photo = news.photoAttachments.first else { return 0 }
                    return (tableView.bounds.width * CGFloat(photo.aspectRatio)).rounded(.up)
                } else if news.gifUrl != "" {
                    return (tableView.bounds.width * CGFloat(news.gifAspectRatio)).rounded(.up)
                } else if news.videoAttachments.count > 0{
                    guard let video = news.videoAttachments.first else { return 0 }
                    return (tableView.bounds.width * CGFloat(video.aspectRatio)).rounded(.up)
                } else {
                    return UITableView.automaticDimension
                }
            default:
                return UITableView.automaticDimension
            }
        case 4:
            switch indexPath.row {
            case 1:
                let text = news.newsText
                let textSize = getLabelSize(text: text, font: UIFont.systemFont(ofSize: 14), maxWidth: tableView.bounds.width)
                let expandedState = expandedCells[indexPath] ?? false
                if expandedState {
                    return UITableView.automaticDimension
                } else {
                    return min(textSize.height + 20, 100)
                }
            case 2:
                guard let news = self.news?[indexPath.section] else {return 0}
                if news.photoAttachments.count > 0 {
                    let photo = news.photoAttachments.first
                    return (tableView.bounds.width * CGFloat(photo!.aspectRatio)).rounded(.up)
                } else if news.gifUrl != ""{
                    return (tableView.bounds.width * CGFloat(news.gifAspectRatio)).rounded(.up)
                } else if news.videoAttachments.count > 0 {
                    guard let video = news.videoAttachments.first else { return 0 }
                    return (tableView.bounds.width * CGFloat(video.aspectRatio)).rounded(.up)
                } else {
                    return UITableView.automaticDimension
                }
            default:
                return UITableView.automaticDimension
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

extension NewsTableViewController {
    func updateSections(deletions: [Int], insertions: [Int], modifications: [Int]) {
        tableView.beginUpdates()
        tableView.deleteSections(IndexSet(deletions), with: .none)
        tableView.insertSections(IndexSet(insertions), with: .none)
        tableView.reloadSections(IndexSet(modifications), with: .none)
        tableView.endUpdates()
    }
}
