//
//  MyPostTableViewCell.swift
//  ios-sns
//
//  Created by 석미혜 on 2023/06/18.
//
import Foundation
import UIKit

class MyPostTableViewCell: UITableViewCell{
    
    @IBOutlet weak var myContentLabel: UILabel!
    
    @IBOutlet weak var likeNum: UILabel!
    @IBOutlet weak var myPostImg: UIImageView!
    @IBOutlet weak var myPostDate: UILabel!
    
    // 쎌이 렌더링 될때
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
