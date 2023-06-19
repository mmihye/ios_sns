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
    @IBOutlet weak var imageView: UIImageView!
    
    @objc func imageViewTapped(_ gesture: UITapGestureRecognizer) {
        // 컨트로러를 생성한다
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self // 이 딜리게이터를 설정하면 사진을 찍은후 호출된다

        imagePickerController.sourceType = .photoLibrary

        present(imagePickerController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromLabel.text = "from."+UserDefaults.standard.string(forKey: "nickName")!
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)

    }
    

}

extension PostViewController {
    @IBAction func sendButton(_ sender: Any) {
        // 성공일때 alert
        let alert = UIAlertController(title: "쪽지보내기", message: "쪽지가 성공적으로 전송되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            self.contentText.text = ""
            self.imageView.image = nil
        })
        
        // 오늘 날짜
        var formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        var current_date_string = formatter.string(from: Date())
        
        
        FirebaseStorageManager.uploadImage(image: imageView.image!, pathRoot: UserDefaults.standard.string(forKey: "nickName")!) { url in
            if let url = url {
                // db 업데이트
                let myRef = UserDefaults.standard.string(forKey: "ref")!
                let Ref = self.db.collection("users").document(myRef).collection("posts")
                Ref.addDocument(data: ["text":self.contentText.text!,"date":current_date_string,"like":0, "img":url.absoluteString]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        

    }
}

extension PostViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // 사진을 찍은 경우 호출되는 함수
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
 
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
        
    }

    // 사진 캡쳐를 취소하는 경우 호출 함수
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // imagePickerController을 죽인다
        picker.dismiss(animated: true, completion: nil)
    }
}

