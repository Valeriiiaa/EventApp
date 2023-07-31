//
//  SwitcherCell.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 25.06.2023.
//

import UIKit

class SwitcherCell: UITableViewCell {

    @IBOutlet weak var backgroundViewSwitcher: UIView!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var labelNotification: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundViewSwitcher.layer.cornerRadius = 12
        backgroundViewSwitcher.layer.masksToBounds = true
        
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
   
    func configure(model: SwitcherStateSectionModel) {
        labelNotification.text = model.title
        guard let state = model.stateModel.state as? Bool else { return }
        switcher.isOn = state
    }
}
