//
//  SortDataList.swift
//  CustomContactApp
//
//  Created by Asif Taher on 3/30/19.
//  Copyright © 2019 Asif Taher. All rights reserved.
//

import Foundation
class SortDataListService{
    func getSortedDataList(dataList: [CustomEntity], searchedName: String)-> [CustomEntity]{
        var dataListWithDistance: [CustomEntity] = getDataWithLevestineDistace(dataList: dataList, searchedName: searchedName)
        dataListWithDistance = dataListWithDistance.sorted{
            return $0.levestainDistance < $1.levestainDistance
        }
        return dataListWithDistance
    }
    private func getDataWithLevestineDistace(dataList: [CustomEntity], searchedName: String)->[CustomEntity]{
        var newDataList: [CustomEntity] = []
        var newDataObj = CustomEntity()
        for dataObj in dataList{
            newDataObj = dataObj
            newDataObj.levestainDistance = DistanceBetweenString.levenshtein(aStr: dataObj.cName, bStr: searchedName)
            newDataList.append(newDataObj)
        }
        return newDataList
    }
    func getSortedDataListUsingBatchNO(dataList: [CustomEntity], searchedBatch: String)-> [CustomEntity]{
        var dataListWithDistance: [CustomEntity] = getSortedDataListUsingBatchNO(dataList: dataList, searchedBatch: searchedBatch)
        dataListWithDistance = dataListWithDistance.sorted{
            return $0.levestainDistance < $1.levestainDistance
        }
        return dataListWithDistance
    }
    private func getDataWithLevestineDistaceUsingBatchNO(dataList: [CustomEntity], searchedBatch: String)->[CustomEntity]{
        var newDataList: [CustomEntity] = []
        var newDataObj = CustomEntity()
        for dataObj in dataList{
            newDataObj = dataObj
            newDataObj.levestainDistance = DistanceBetweenString.levenshtein(aStr: dataObj.cBatchNO, bStr: searchedBatch)
            newDataList.append(newDataObj)
        }
        return newDataList
    }
}
