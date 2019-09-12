//
//  WorkPlaceSelectionViewController.swift
//  CustomContactApp
//
//  Created by Asif Taher on 4/1/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import UIKit
protocol WorkPlaceProtocol: class{
    func getWorkPlace(selectedWorkPlace: String)
}
class WorkPlaceSelectionViewController: UIViewController {
    var workPlaceList: [String] = Array(Constants.workPlaceList)
    @IBOutlet weak var selectWorkPlaceLabel: UILabel!
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    weak var workPlaceDelegate: WorkPlaceProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        workPlaceList = defaults.object(forKey: Constants.workPlaceUserDefaultKey) as? [String] ?? [String]()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func configureTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension WorkPlaceSelectionViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workPlaceList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = workPlaceList[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        workPlaceDelegate?.getWorkPlace(selectedWorkPlace: workPlaceList[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}

