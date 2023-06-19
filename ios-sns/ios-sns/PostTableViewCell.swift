//
//  PostTableViewCell.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/17.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore

class PostTableViewCell: UITableViewCell{
    let db = Firestore.firestore()
    
    @IBOutlet weak var userContentLabel: UILabel!
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userPostDate: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userNickname: UILabel!
    @IBOutlet weak var userProfileImg: UIImageView!
    
    @IBOutlet weak var likeNum: UILabel!
    
    // 쎌이 렌더링 될때
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userProfileImg.layer.cornerRadius = userProfileImg.frame.height / 2
        
    }
    
    @IBAction func likeButton(_ sender: UIButton) {
        
        db.collection("users").whereField("nickName", isEqualTo: userNickname.text!).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let id = document.data()["id"] as! String
                    let documentId = document.documentID
                    self.db.collection("users").document(documentId).collection("posts")
                        .whereField("text", isEqualTo: self.userContentLabel.text!).getDocuments { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    self.db.collection("users").document(documentId).collection("posts").document(document.documentID)
                                        .updateData(["like" : FieldValue.increment(Int64(1))])
                                    self.db.collection("users").document(documentId).collection("posts").document(document.documentID)
                                        .getDocument { (document, error) in
                                            if let document = document, document.exists {
                                                let num = document.data()!["like"] as! Int
                                                self.likeNum.text = "\(num)개"
                                            } else {
                                                print("Document does not exist")
                                            }
                                        }
                                }
                                
                            }
                            
                        }
                }
                
            }
        }
        
    }

}
