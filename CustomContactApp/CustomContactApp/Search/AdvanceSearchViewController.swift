//
//  AdvanceSearchViewController.swift
//  CustomContactApp
//
//  Created by Asif Taher on 4/1/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import UIKit

class AdvanceSearchViewController: UIViewController, UITextFieldDelegate {
    var adSearchTableData: [String] = ["Present Post", "Workplace", "Designation"]
    var isPresentPostChanged: Bool = false
    var isWorkPlaceChanged: Bool = false
    var isDesignationChanged: Bool = false
    let presentPostRowIndex = 0
    let workPlaceRowIndex = 1
    let designationRowIndex = 2
    var resultDataList: [CustomEntity] = []
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var batchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var resetAllBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Advance Search"
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dismissKeyBoard))
        //tap.numberOfTapsRequired = 2
        //tap.numberOfTouchesRequired = 2
        resetAllBtn.backgroundColor = .clear
        resetAllBtn.layer.cornerRadius = 5
        resetAllBtn.layer.borderWidth = 1
        resetAllBtn.layer.borderColor = UIColor.blue.cgColor
        configureTableView()
        //self.view.addGestureRecognizer(tap)
        self.nameTextField.delegate = self
        self.batchTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
   @objc func dismissKeyBoard(){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    fileprivate func configureTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    @IBAction func resetAllBtnAction(_ sender: Any) {
        self.nameTextField.text = ""
        self.batchTextField.text = ""
        adSearchTableData = ["Present Post", "Workplace", "Designation"]
        tableView.reloadData()
    }
    
    @IBAction func searchBtnAction(_ sender: Any) {
        // start search from DATA
        let nameText: String = self.nameTextField.text ?? ""
        let batchText: String = self.batchTextField.text ?? ""
        let sortServiceObj: SortDataListService = SortDataListService()
        if(adSearchTableData[0] != "Present Post"){
            isPresentPostChanged = true
        }
        if(adSearchTableData[1] != "Workplace"){
            isWorkPlaceChanged = true
        }
        if(adSearchTableData[2] != "Designation"){
            isDesignationChanged = true
        }
        self.resultDataList = Constants.allContactData
        if(nameText.count > 0){
            self.resultDataList = sortServiceObj.getSortedDataList(dataList: resultDataList, searchedName: nameText)
        }
        if(batchText.count > 0){
            self.resultDataList = sortServiceObj.getSortedDataListUsingBatchNO(dataList: resultDataList, searchedBatch: batchText)
        }
        if(isPresentPostChanged){
            self.resultDataList = self.resultDataList.filter{ $0.cPresentPost == adSearchTableData[presentPostRowIndex] }
        }
        if(isDesignationChanged){
            self.resultDataList = self.resultDataList.filter{ $0.cDesignation == adSearchTableData[designationRowIndex] }
        }
        if(isWorkPlaceChanged){
            self.resultDataList = self.resultDataList.filter{ $0.cWorkPlace == adSearchTableData[workPlaceRowIndex] }
        }
        self.resultDataList = getTenBestResult(sortedDataList: self.resultDataList)
        gotoNextPageWithData(data: self.resultDataList)
    }
    
    fileprivate func getTenBestResult(sortedDataList: [CustomEntity])-> [CustomEntity]{
        var newDataList: [CustomEntity] = []
        var limit: Int = 20
        if(sortedDataList.count < limit){
            limit = sortedDataList.count
        }
        for index in 0 ..< limit{
            newDataList.append(resultDataList[index])
        }
        return newDataList
    }
    fileprivate func gotoNextPageWithData(data: [CustomEntity]){
        let searchResultVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.advanceSearchResultStoryBoardID)as! AdvanceSearchResultViewController
        searchResultVC.resultDataList = data
        self.navigationController?.pushViewController(searchResultVC, animated: true)
    }
}
extension AdvanceSearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adSearchTableData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = adSearchTableData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == presentPostRowIndex){
            let viewController: PresentPostSelectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.presentPostStoryBoardID) as! PresentPostSelectionViewController
            viewController.modalPresentationStyle = .popover
            viewController.presentPostDelegate = self
            self.present(viewController, animated: true)
        }
        else if(indexPath.row == workPlaceRowIndex){
            let viewController: WorkPlaceSelectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.workPlaceStoryBoarID) as! WorkPlaceSelectionViewController
            viewController.modalPresentationStyle = .popover
            viewController.workPlaceDelegate = self
            self.present(viewController, animated: true)

        }
        else if(indexPath.row == designationRowIndex){
            let viewController: DesignationSelectionViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.designationStoryBoardID) as! DesignationSelectionViewController
            viewController.modalPresentationStyle = .popover
            viewController.designationDelegate = self
            self.present(viewController, animated: true)

        }
    }
}

extension AdvanceSearchViewController: PresentPostProtocol{
    func getPresentPost(presentPost: String) {
        adSearchTableData[presentPostRowIndex] = presentPost
        tableView.reloadData()
    }
}

extension AdvanceSearchViewController: WorkPlaceProtocol{
    func getWorkPlace(selectedWorkPlace: String) {
        adSearchTableData[workPlaceRowIndex] = selectedWorkPlace
        tableView.reloadData()
    }
}
extension AdvanceSearchViewController: DesignationSelectionProtocol{
    func getDesignation(selectedDesignation: String) {
        adSearchTableData[designationRowIndex] = selectedDesignation
        tableView.reloadData()
    }
}






















