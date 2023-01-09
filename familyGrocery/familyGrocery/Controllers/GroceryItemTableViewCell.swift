//
//  GroceryItemTableViewCell.swift
//  familyGrocery
//
//  Created by TAIF Al-zahrani on 16/06/1444 AH.
//

import UIKit

class GroceryItemTableViewCell: UITableViewCell {
    let itemNameLable : UILabel = {
        let lbl = UILabel()
        lbl.font = lbl.font.withSize(24)
        lbl.numberOfLines = 2
        return lbl
    }()
    
     let addedByUserLable : UILabel = {
        let lbl = UILabel()
        lbl.font = lbl.font.withSize(14)
        lbl.numberOfLines = 2
        return lbl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        layOut()
    }
    
    
    private func layOut(){
        self.contentView.addSubview(itemNameLable)
        self.contentView.addSubview(addedByUserLable)
        
        itemNameLable.translatesAutoresizingMaskIntoConstraints = false
        addedByUserLable.translatesAutoresizingMaskIntoConstraints = false
        
        itemNameLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        itemNameLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true

        addedByUserLable.topAnchor.constraint(equalTo: itemNameLable.bottomAnchor, constant: 8).isActive = true
        addedByUserLable.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
    }

}
