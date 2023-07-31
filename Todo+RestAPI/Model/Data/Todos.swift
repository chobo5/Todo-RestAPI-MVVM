//
//  Todos.swift
//  Todo+RestAPI
//
//  Created by 원준연 on 2023/01/26.
//

import Foundation
import UIKit

//MARK: - TodoResponse
//struct TodoResponse: Codable {
//    var todos = [Todo]()
//}


// MARK: - Todo
struct Todo: Codable {
    var colorCount: Int?
    var content: String?
    var createdDate : String?
    var id: Int?
    var imageURL: String?
    var modifiedDate: String?
    var progressCount: Int?
    var title: String?
    
    var isEdited: Bool? = false
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case imageURL = "imageURl"
        case content ,modifiedDate ,title ,createdDate
        case id, progressCount, colorCount
        
    }
}









