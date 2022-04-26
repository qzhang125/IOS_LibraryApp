//
//  BookClass.swift
//  a4-QiuyuZhang-qzhang125
//
//  Created by Qiuyu Zhang on 2022-04-05.
//

import Foundation
class BookClass{
    var id:String
    var title:String
    var author:String
    var borrower: String
    var availability:Bool{
        get{
            if(borrower != ""){
                return false
            }else{
                return true
            }
        }
    }
    
    init(id:String, title:String,author:String,borrower:String){
        self.id = id
        self.title = title
        self.author = author
        self.borrower = borrower
    }
    
    func setBorrower(borrow:String){
        self.borrower = borrow
    }
}

