//
//  ProfileViewController.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/17.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage


public struct MyPost: Codable {

    let text: String
    let date: String
    let like: Int
    let img: String
}

class ProfileViewController: UIViewController, UITabBarControllerDelegate{
    let db = Firestore.firestore()
    
    @IBOutlet weak var myProfileImg: UIImageView!
    
    @IBOutlet weak var myNickName: UILabel!
    @IBOutlet weak var myId: UILabel!
    
    @IBOutlet weak var myPostTableView: UITableView!
    
    @IBAction func EditButton(_ sender: UIButton) {
        if myPostTableView.isEditing == true{
            myPostTableView.isEditing = false
            sender.setTitle("게시물 편집", for: .normal)
        }else{
            myPostTableView.isEditing = true
            sender.setTitle("완료", for: .normal)
        }

    }
    
    
    var contentArray: Array<MyPost> = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        contentArray.removeAll()
         
         // Create a DispatchGroup
         let group = DispatchGroup()

         // Enter the DispatchGroup before the Firestore operation
         group.enter()
         
         db.collection("users").document(UserDefaults.standard.string(forKey: "ref")!).getDocument { (document, error) in
             if let document = document, document.exists {
                 let urlString = document.data()!["profileImg"] as! String
                 FirebaseStorageManager.downloadImage(urlString: urlString) { [weak self] image in
                         self?.myProfileImg.image = image
                     }
             } else {
                 print("Document does not exist")
             }
         }

         db.collection("users").document(UserDefaults.standard.string(forKey: "ref")!).collection("posts")
             .getDocuments{ (querySnapshot, error) in
             defer {
                 // Leave the DispatchGroup when the Firestore operation completes
                 group.leave()
             }

             if let error = error {
                 print("Error getting documents: \(error)")
             } else {
                 for document in querySnapshot!.documents {
                     print("\(document.documentID) => \(document.data())")
                     let myPost = MyPost(text: document.data()["text"] as! String, date: document.data()["date"] as! String, like : document.data()["like"] as! Int,
                                         img: document.data()["img"] as! String)
                     self.contentArray.append(myPost)
                 }
             }
         }

         // Notify the DispatchGroup when all asynchronous tasks are complete
         group.notify(queue: .main) {
             // Perform your synchronous tasks here, such as configuring the table view
             self.myPostTableView.rowHeight = UITableView.automaticDimension
             self.myPostTableView.estimatedRowHeight = 120

             // Reload the table view data
             self.myPostTableView.reloadData()
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.delegate = self

        // Do any additional setup after loading the view.
        myProfileImg.layer.cornerRadius = myProfileImg.frame.height / 2
        
        myNickName.text = UserDefaults.standard.string(forKey: "nickName")
        myId.text = "@"+UserDefaults.standard.string(forKey: "id")!
       
        self.myPostTableView.delegate = self
        self.myPostTableView.dataSource = self
        self.myPostTableView.isEditing = false
    
    }
    
}

extension ProfileViewController: UITableViewDataSource{
    // 테이블 뷰 쎌의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contentArray.count
    }
    
    // 각 쎌에 대한 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myPostTableView.dequeueReusableCell(withIdentifier: "MyPostTableViewCell", for: indexPath) as! MyPostTableViewCell
        
        cell.myContentLabel.text = contentArray[indexPath.row].text
        cell.myPostDate.text = contentArray[indexPath.row].date
    
        let likeCount = contentArray[indexPath.row].like
        cell.likeNum.text = "\(likeCount)개"
        
        FirebaseStorageManager.downloadImage(urlString: contentArray[indexPath.row].img) { [weak self] image in
            cell.myPostImg.image = image
        }
        
        return cell
    }
    
}
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = self.contentArray[indexPath.row]
            let currentUserRef = UserDefaults.standard.string(forKey: "ref")!
            
            db.collection("users").document(currentUserRef).collection("posts")
                .whereField("text", isEqualTo: post.text).getDocuments() { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        guard let documents = querySnapshot?.documents else { return }
                        for document in documents {
                            let documentID = document.documentID
                            self.db.collection("users").document(currentUserRef).collection("posts")
                                .document(documentID).delete { error in
                                    if let error = error {
                                        print("Error removing document: \(error)")
                                    } else {
                                        print("Document successfully removed!")
                                        // Update the data and UI after deleting the item
                                        self.contentArray.remove(at: indexPath.row)
                                        tableView.reloadData()
                                    }
                                }
                        }
                    }
            }
        }
    }
}
