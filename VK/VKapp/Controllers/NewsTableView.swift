//
//  TableViewController.swift
//  VKapp
//
//  Created by Юрий Султанов on 23.07.2019.
//  Copyright © 2019 Юрий Султанов. All rights reserved.
//

import UIKit
import RealmSwift

class NewsTableView: UITableViewController {
//    private var news = [
//        News(Avatar: UIImage(named: "file")!, Name: "QWERTY", Text: "Транзакция, достигающая своего нормального завершения (EOT — end of transaction, завершение транзакции) и, тем самым, фиксирующая свои результаты, сохраняет согласованность базы данных. Другими словами, каждая успешная транзакция по определению фиксирует только допустимые результаты. Это условие является необходимым для поддержки четвёртого свойства. Согласованность является более широким понятием. Например, в банковской системе может существовать требование равенства суммы, списываемой с одного счёта, сумме, зачисляемой на другой. Это бизнес-правило и оно не может быть гарантировано только проверками целостности, его должны соблюсти программисты при написании кода транзакций. Если какая-либо транзакция произведёт списание, но не произведёт зачисления, то система останется в некорректном состоянии и свойство согласованности будет нарушено.Наконец, ещё одно замечание касается того, что в ходе выполнения транзакции согласованность не требуется. В нашем примере, списание и зачисление будут, скорее всего, двумя разными подоперациями и между их выполнением внутри транзакции будет видно несогласованное состояние системы. Однако не нужно забывать, что при выполнении требования изоляции никаким другим транзакциям эта несогласованность не будет видна. А атомарность гарантирует, что транзакция либо будет полностью завершена, либо ни одна из операций транзакции не будет выполнена. Тем самым эта промежуточная несогласованность является скрытой."),
//        News(Avatar: UIImage(named: "birko")!, Name: "Test", Text: "Сделать группировку друзей по первой букве фамилии. Добавить header секции для таблицы со списком друзей. Он должен содержать первую букву фамилии и иметь полупрозрачный цвет фона, цвет которого совпадает с цветом таблицы.", Photos: [UIImage(named: "file")!, UIImage(named: "birko")!, UIImage(named: "depp")!
//            ])
//    ]
    
    let networkService = NetworkService()
    private lazy var news = try? Realm().objects(News.self)
    
    @objc private var like = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let NewsTopCellNib = UINib (nibName: "NewsTopCell", bundle: nil)
        let NewsBottomCellNib = UINib (nibName: "NewsBottomCell", bundle: nil)
        tableView.register(NewsTopCellNib, forCellReuseIdentifier: "NewsTopCell")
        tableView.register(NewsBottomCellNib, forCellReuseIdentifier: "NewsBottomCell")
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let news=news else { return 0}
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = news else {return 0}
        return news[section].numberOfRows
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let news = news else {preconditionFailure("news at cellForRowAt..")}
        switch indexPath.row {
        case 0:
            let cellTop = tableView.dequeueReusableCell(withIdentifier: "NewsTopCell", for: [0]) as? NewsTopCell
            cellTop.configureNewsTop(with: news[indexPath.section])
            return cellTop
        case news[indexPath.section].numberOfRows - 1]:
            cellBottom.configureNewsBottom(with: news[indexPath.section])
            return cellBottom
        default:
            cellTop.configureNewsTop(with: news[indexPath.section])
            return cellTop
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
    
    
    @objc private func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo as NSDictionary?
        let keyboardSize = (info?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWasHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
}
