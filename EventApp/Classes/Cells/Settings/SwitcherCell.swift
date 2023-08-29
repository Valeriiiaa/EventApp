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
    
    private weak var model: SwitcherStateSectionModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundViewSwitcher.layer.cornerRadius = 12
        backgroundViewSwitcher.layer.masksToBounds = true
    }
   
    func configure(model: SwitcherStateSectionModel) {
        labelNotification.text = model.title
        guard let state = model.stateModel.state as? Bool else { return }
        switcher.isOn = state
        self.model = model
    }
    
    @IBAction func valueDidChanged(_ sender: Any) {
        guard model?.type != StateType.alarmSwitch.rawValue else {
            switcher.isOn = true
            return
        }
        model?.stateModel.state = switcher.isOn
    }
}
