//  UsersViewController.swift
//  MobileCodingChallenge
//  Created by Deeksha Verma on 17/08/22.

import UIKit

class UsersViewController: UIViewController {
    var userList = [UserList]()
    @IBOutlet weak var userTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        userTableView.tableFooterView = UIView()
        if let path = Bundle.main.path(forResource: "test", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                print(jsonResult)
                userList = try JSONDecoder().decode([UserList].self, from: data)
            } catch {}
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(back(sender:)))
        navigationItem.leftBarButtonItem = newBackButton
    }
    
    /// Back Button Action
    /// - Parameter sender: UIBarButtonItem
    @objc func back(sender:UIBarButtonItem) {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "No", style: UIAlertAction.Style.default) {[weak self] (result : UIAlertAction) -> Void in
            self?.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {[weak self] (result : UIAlertAction) -> Void in
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    //nameHeader
    //MARK: Tableview delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return userList.count
    }
    
    /// Number Of Rows In Section
    /// - Parameters:
    ///   - tableView: UITableview for notes listing.
    /// - Returns: number of sections based on list.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    /// This method is used for providing values which are present in tableview
    /// - Parameters:
    ///   - tableView: UITableView for note listing
    /// - Returns: returns value which are present in UITableView cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "nameHeader")!
            let label = cell.viewWithTag(1) as! UILabel
            label.text = userList[indexPath.section].name ?? ""
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
            let label = cell.viewWithTag(1) as! UILabel
            label.text = "Username: \(userList[indexPath.section].username ?? "")"
            break
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
            let label = cell.viewWithTag(1) as! UILabel
            label.text = "Email: \(userList[indexPath.section].email ?? "")"
            break
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
            let label = cell.viewWithTag(1) as! UILabel
            label.text = "Address: " +  (userList[indexPath.section].address?.suite ?? "") + ", "
            label.text?.append((userList[indexPath.section].address?.street ?? "") + ", ")
            label.text?.append((userList[indexPath.section].address?.city ?? "") + ", ")
            label.text?.append(userList[indexPath.section].address?.zipcode ?? "")
            break
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
            let label = cell.viewWithTag(1) as! UILabel
            label.text = "Phone: \(userList[indexPath.section].phone ?? "")"
            break
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
            let label = cell.viewWithTag(1) as! UILabel
            label.text = "Website: \(userList[indexPath.section].website ?? "")"
            break
        case 6:
            cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
            let label = cell.viewWithTag(1) as! UILabel
            label.text = "Company: " +  (userList[indexPath.section].company?.name
                                         ?? "") + " - "
            label.text?.append((userList[indexPath.section].company?.catchPhrase ?? "") + " (")
            label.text?.append((userList[indexPath.section].company?.bs ?? "") + ")")
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        return UITableView.automaticDimension
    }
}
