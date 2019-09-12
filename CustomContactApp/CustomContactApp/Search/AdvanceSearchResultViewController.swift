//
//  AdvanceSearchResultViewController.swift
//  CustomContactApp
//
//  Created by Asif Taher on 4/5/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import UIKit

class AdvanceSearchResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var resultDataList : [CustomEntity] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Advance Search Result"
        self.configureTableView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(resultDataList.count == 0){
            self.showErrorAlert()
        }
    }
    fileprivate func showErrorAlert(){
        // create the alert
        let alert = UIAlertController(title: "Try again!", message: "No data found this time.", preferredStyle: .alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: false)
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    fileprivate func configureTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        let customContactCell = UINib(nibName: "CustonContactTableViewCell", bundle: nil)
        self.tableView.register(customContactCell, forCellReuseIdentifier: CustonContactTableViewCell.cellIdentifier)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    fileprivate func gotoNextPageWithData(data: CustomEntity){
        let contactDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "contactDetailsViewControllerStoryBoard")as! ContactDetailsViewController
        contactDetailsVC.contactDetailsData = data
        self.navigationController?.pushViewController(contactDetailsVC, animated: true)
    }

}

extension AdvanceSearchResultViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultDataList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CustonContactTableViewCell.cellIdentifier) as? CustonContactTableViewCell{
            cell.nameLabel.text = resultDataList[indexPath.row].cName
            cell.presentPostLabel.text = resultDataList[indexPath.row].cPresentPost
            cell.customContactCellButtonDelegate = self
            cell.moreButton.tag = indexPath.row
            if(indexPath.row % 2 == 0){
                cell.backgroundColor = Constants.LIGHT_GREY_COLOR
            }
            else{
                cell.backgroundColor = UIColor.white
            }
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        gotoNextPageWithData(data: resultDataList[indexPath.row])
    }
}

extension AdvanceSearchResultViewController: CustomContactCellButtonProtocol{
    func didPressCustomCellButton(_ tag: Int) {
        print("tapped button index = \(tag)")
        // show call, msg, mail options
        let alertMsg = "contact with " + resultDataList[tag].cName + "."
        let alert = UIAlertController(title: "Contact Now!", message: alertMsg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (_) in
            let number = "tel://+88" + self.resultDataList[tag].cPersonalMobile
            UIApplication.shared.open(URL(string: number)!, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Message", style: .default, handler: { (_) in
            let number = "sms:+88" + self.resultDataList[tag].cPersonalMobile
            UIApplication.shared.open(URL(string: number)!, options: [:], completionHandler: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Mail", style: .default, handler: { (_) in
            let email = self.resultDataList[tag].cEmail
            if let url = URL(string: "mailto:\(email)"){
                if #available(iOS 10.0, *){
                    UIApplication.shared.open(url)
                }
                else{
                    UIApplication.shared.openURL(url)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
