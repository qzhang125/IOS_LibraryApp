//
//  Book.swift
//  a4-QiuyuZhang-qzhang125
//
//  Created by Qiuyu Zhang on 2022-04-05.
//

import Foundation
import FirebaseFirestoreSwift

struct Book:Codable{
    @DocumentID var id:String?
    var title:String
    var author:String
    var borrower: String
    var availability:Bool
}
