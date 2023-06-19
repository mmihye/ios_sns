//
//  SearchTableViewCell.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/18.
//
import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore

class SearchTableViewCell: UITableViewCell{
    let db = Firestore.firestore()
    
    @IBOutlet weak var userProfileImg: UIImageView!
    
    @IBOutlet weak var userNickname: UILabel!
    
    @IBOutlet weak var userId: UILabel!
    
    @IBOutlet weak var followButton: UIButton!
    
    @IBAction func followButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Follow"{
            db.collection("users").document(UserDefaults.standard.string(forKey: "ref")!).updateData([
                "friends": FieldValue.arrayUnion([userNickname.text])
            ])
            sender.setTitle("UnFollow", for: .normal)
            sender.setTitleColor(UIColor.gray, for: .normal)
        }else{
            db.collection("users").document(UserDefaults.standard.string(forKey: "ref")!).updateData([
                "friends": FieldValue.arrayRemove([userNickname.text])
            ])
            sender.setTitle("Follow", for: .normal)
            sender.setTitleColor(UIColor.orange, for: .normal)
        }

    }
    // 쎌이 렌더링 될때
    override func awakeFromNib() {
        super.awakeFromNib()
        userProfileImg.layer.cornerRadius = userProfileImg.frame.height / 2
        
        // 친구인지 확인
        db.collection("users").document(UserDefaults.standard.string(forKey: "ref")!).getDocument { (document, error) in
            if let document = document, document.exists {
                if let data = document.data() {
                    if let friends = data["friends"] as? Array<String> {
                        if friends.contains(self.userNickname.text!) {
                            self.followButton.setTitle("UnFollow", for: .normal)
                            self.followButton.setTitleColor(UIColor.gray, for: .normal)
                        }
                        
                    }
                    
                }
                
            }
            
        }
    }
    
}
