//
//  PostViewController.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/17.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


class PostViewController: UIViewController {
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromLabel.text = "from."+UserDefaults.standard.string(forKey: "nickName")!
        
    }
    

}

extension PostViewController {
    @IBAction func sendButton(_ sender: Any) {
        // 성공일때 alert
        let alert = UIAlertController(title: "쪽지보내기", message: "쪽지가 성공적으로 전송되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            self.contentText.text = ""
        })
        
        // 오늘 날짜
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        var current_date_string = formatter.string(from: Date())
        
        // db 업데이트
        let myRef = UserDefaults.standard.string(forKey: "ref")!
        let Ref = db.collection("users").document(myRef).collection("posts")
        Ref.addDocument(data: ["text":contentText.text!,"date":current_date_string]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
}
