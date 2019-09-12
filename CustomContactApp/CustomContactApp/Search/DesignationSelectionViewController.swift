//
//  DesignationSelectionViewController.swift
//  CustomContactApp
//
//  Created by Asif Taher on 4/1/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import UIKit
protocol DesignationSelectionProtocol: class {
    func getDesignation(selectedDesignation: String)
}
class DesignationSelectionViewController: UIViewController {
    var designationList: [String] = Array(Constants.designationList)
    @IBOutlet weak var selectDesignationLAbel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    weak var designationDelegate: DesignationSelectionProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        designationList = defaults.object(forKey: Constants.designationUserDefaultKey) as? [String] ?? [String]()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configureTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension DesignationSelectionViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return designationList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = designationList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        designationDelegate?.getDesignation(selectedDesignation: designationList[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
