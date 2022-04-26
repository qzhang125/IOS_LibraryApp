//
//  ViewController.swift
//  a4-QiuyuZhang-qzhang125
//
//  Created by Qiuyu Zhang on 2022-04-04.
//

import UIKit
//Connecting to firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ViewController: UIViewController {
    //OUTLETS:
    @IBOutlet weak var userNameTextView: UITextField!
    @IBOutlet weak var passwordTextView: UITextField!
    @IBOutlet weak var errorMsgLbl: UILabel!
    @IBOutlet weak var logInBtn: UIButton!
    
    //Get a reference to the firebase
    let firedb = Firestore.firestore()
    
    var bookList:[BookClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Load the library from firebase
        firedb.collection("Library").getDocuments {
            (query, error) in
            if let err = error{
                print("Error getting documents from the collection")
                print(err)
                return
            }
            for document in query!.documents{
                print(document.documentID)
                do{
                    let storedBook = try document.data(as:Book.self)
                    let newBook = BookClass(id: storedBook!.id ?? "Not Given", title: storedBook!.title, author: storedBook!.author, borrower: storedBook!.borrower)
                    self.bookList.append(newBook)
                }catch{
                    print(error)
                }
            }
        }
    }
    
    
    @IBAction func logInBtnPressed(_ sender: Any) {
        let name = userNameTextView.text
        let pass = passwordTextView.text
        let userInput:[String : String] = ["username": name ?? "", "password": pass ?? ""]
        
        
        firedb.collection("User credentials").getDocuments { [self]
            (queryResults, error)
            in
            //error checking
            if let err = error{
                print("Error getting documents from the collection")
                print(err)
                return
            }
            //ok
            if(queryResults!.count == 0){
                print("No user credentials can be found in the collection")
            }else{
                for document in queryResults!.documents{
                    let name:String = document.get("username") as! String
                    let pass:String = document.get("password") as! String
                    let storedInfo:[String: String] = ["username": name, "password": pass]
                    //print("-----stored info-----")
                    //print(storedInfo)
                    //print("-----input info-----")
                    //print(userInput)
                    
                    if(userInput == storedInfo){
                        self.errorMsgLbl.text = " "
                        guard let libScreen = storyboard?.instantiateViewController(withIdentifier: "libraryScreen") as? LibraryViewController else{
                            print("Error: cant find a screen")
                            return
                        }
                        
                        //Send the username to library page
                        libScreen.userName = name
                        libScreen.bookList = self.bookList
                        self.show(libScreen,sender: self)
                        return
                    }else{
                        self.errorMsgLbl.text = "Error login credentials, please try again"
                    }
                }
            }
        }
    }
}

