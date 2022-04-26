//
//  LibraryViewController.swift
//  a4-QiuyuZhang-qzhang125
//
//  Created by Qiuyu Zhang on 2022-04-05.
//

import UIKit
import FirebaseFirestore

class LibraryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var bookList:[BookClass] = []
    var userName:String = ""
    let firedb = Firestore.firestore()
    
    //OUTLET
    @IBOutlet weak var libTableView: UITableView!
    @IBOutlet weak var lblWelcome: UILabel!
    
    @IBOutlet weak var lblWarning: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        libTableView.delegate = self
        libTableView.dataSource = self
        
        //Print the username
        lblWelcome.text = "Welcome, \(userName)"
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(bookList.count)
        return bookList.count
    }
    
    //Define each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = libTableView.dequeueReusableCell(withIdentifier: "libCell", for:indexPath) as! LibTableViewCell
        let book:BookClass = bookList[indexPath.row]
        cell.lblBookName.text = book.title
        if(!book.availability){
            cell.lblSubtitle.text = "\(book.author) -- borrowed by \(book.borrower)"
        }else{
            cell.lblSubtitle.text = book.author
        }
        return cell
    }
    
    //Borrowed a book
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If the book is availble to borrow
        if(bookList[indexPath.row].availability){
            bookList[indexPath.row].setBorrower(borrow: userName)
            print("\(bookList[indexPath.row].title) has been borrowed successfully by \(userName)")
            
            //Update borrower info
            let bookToUpdate = Book(title: bookList[indexPath.row].title, author: bookList[indexPath.row].author, borrower: userName, availability: false)
            do{
                try firedb.collection("Library").document(bookList[indexPath.row].id).setData(from: bookToUpdate)
                print("Successfully updated borrower info")
            }catch{
                print("Error updating")
            }
            self.lblWarning.text = "\(bookList[indexPath.row].title) has been borrowed successfully by \(userName)"
            
        }else{
            self.lblWarning.text = "This book is not available for borrowing, it is borrowed by \(bookList[indexPath.row].borrower)"
        }
        libTableView.reloadData()
    }
    
    
    //Return a book
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(!bookList[indexPath.row].availability && bookList[indexPath.row].borrower == self.userName){
            if (editingStyle == UITableViewCell.EditingStyle.delete){
                //Set the borrower to empty
                bookList[indexPath.row].setBorrower(borrow: "")
                self.lblWarning.text = "Successfully returned \(bookList[indexPath.row].title)"
                
                //Upadate the book info
                let bookToUpdate = Book(title: bookList[indexPath.row].title, author: bookList[indexPath.row].author, borrower: "", availability: true)
                
                //Send the object to firebase
                do{
                    try firedb.collection("Library").document(bookList[indexPath.row].id).setData(from: bookToUpdate)
                    print("Successfully updated return info")
                }catch{
                    print("Error updating")
                }
                
                //Refresh the screen
                libTableView.reloadData()
            }
        }else if(bookList[indexPath.row].availability){
            self.lblWarning.text = "You can't return a book which is available"
        }else if(bookList[indexPath.row].borrower != self.userName){
            self.lblWarning.text = "You can't return this book for \(bookList[indexPath.row].borrower)"
        }
    }
}
