//
//  ProfileViewController.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/17.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


public struct MyPost: Codable {

    let text: String
    let date: String

}

class ProfileViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myProfileImg.layer.cornerRadius = myProfileImg.frame.height / 2
        
        myNickName.text = UserDefaults.standard.string(forKey: "nickName")
        myId.text = "@"+UserDefaults.standard.string(forKey: "id")!
        
        
        // Create a DispatchGroup
        let group = DispatchGroup()

        // Enter the DispatchGroup before the Firestore operation
        group.enter()

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
                    let myPost = MyPost(text: document.data()["text"] as! String, date: document.data()["date"] as! String)
                    self.contentArray.append(myPost)
                }
            }
        }

        // Notify the DispatchGroup when all asynchronous tasks are complete
        group.notify(queue: .main) {
            // Perform your synchronous tasks here, such as configuring the table view
            self.myPostTableView.rowHeight = UITableView.automaticDimension
            self.myPostTableView.estimatedRowHeight = 120
            
            self.myPostTableView.delegate = self
            self.myPostTableView.dataSource = self
            self.myPostTableView.isEditing = false

            // Reload the table view data
            self.myPostTableView.reloadData()
        }
    
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
    
        
        return cell
    }
    
}

extension ProfileViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            
        var documentID = ""
        
        if editingStyle == .delete{
            // 선택된 row의 플랜을 가져온다
            let post = self.contentArray[indexPath.row]
            db.collection("users").document(UserDefaults.standard.string(forKey: "ref")!).collection("posts")
                .whereField("text", isEqualTo: post.text).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            print("\(document.documentID) => \(document.data())")
                            documentID = document.documentID
                            self.db.collection("users").document(UserDefaults.standard.string(forKey: "ref")!).collection("posts")
                                .document(documentID).delete() { err in
                                    if let err = err {
                                        print("Error removing document: \(err)")
                                    } else {
                                        print("Document successfully removed!")
                                        self.myPostTableView.reloadData()
                                    }
                                }
                        }
                    }
            }
            
            

            }
    }
}



