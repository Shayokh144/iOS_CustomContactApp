//
//  CSVManager.swift
//  CustomContactApp
//
//  Created by Asif Taher on 3/30/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import Foundation

class CSVManager{
    func getDataFromCSV(fileName: String)-> CustomEntity{
        var dataArray : [String] = []
        if  let path = Bundle.main.path(forResource: fileName, ofType: "csv")
        {
            dataArray = []
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                let dataEncoded = String(data: data, encoding: .utf8)
                if  let dataArr = dataEncoded?.components(separatedBy: "\r\n").map({ $0.components(separatedBy: ",") })
                {
                    for row in dataArr
                    {
                        for cellData in row{
                            print(cellData)
                        }
                    }
                }
            }
            catch let jsonErr {
                print("\n Error read CSV file: \n ", jsonErr)
            }
        }
        return CustomEntity()
    }
}
