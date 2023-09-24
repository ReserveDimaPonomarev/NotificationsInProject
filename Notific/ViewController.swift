//
//  ViewController.swift
//  Notific
//
//  Created by Дмитрий Пономарев on 20.04.2023.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    let notificationsType = ["Local Notification", "Local Notification with Action", "Local Notification with Content", "Push Notification with APNs", "Push Notification with Firebase", "Push Notification with Content"]
    
    let notifications = Notifications()
    
    let tableView = UITableView()
    var selectedRow: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        tableView.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.separatorColor = .white
        
    }
    
    func showAlert(notificationType: String) {
        let alert = UIAlertController(title: notificationType, message: "After 5 seconds Local Notification will apear", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { _ in
            alert.dismiss(animated: true)
            self.notifications.scheduleNotification(notificationType: notificationType)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationsType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        let model = notificationsType[indexPath.row]
        if indexPath.row == selectedRow {
            cell.configureView(model, selected: true)
            cell.contentView.backgroundColor = .yellow.withAlphaComponent(0.4)
        } else {
            cell.configureView(model, selected: false)
            
        }
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Notifications"
        label.font = .boldSystemFont(ofSize: 40)
        label.textColor = .black
        headerView.addSubview(label)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        tableView.reloadRows(at: [indexPath], with: .fade)
        showAlert(notificationType: notificationsType[indexPath.row])
    }
}
