//
//  MenuCell.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 30.06.2023.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var menuText: UILabel!
    @IBOutlet weak var menuImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

}
    
    func configure(label: String, picture: String) {
        menuText.text = label
        menuImage.image = UIImage(named: picture)
    }
}
