//
//  GalleryCollectionViewCell.swift
//  Demo-Unistroy
//
//  Created by Maxim Spiridonov on 11/03/2019.
//  Copyright © 2019 Maxim Spiridonov. All rights reserved.
//

import UIKit

class FurnitureCollectionViewCell: UICollectionViewCell {
    static let reuseId = "FurnitureCollectionViewCell"
    
    let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.shadowOpacity = 0
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mainImageView)
        addSubview(nameLabel)
       
        
        
        
        
        backgroundColor = .white
        
        // mainImageView constraints
        mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        mainImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainImageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        // nameLabel constraints
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 2.2).isActive = true
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5
        self.layer.shadowRadius = 6
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        
        self.clipsToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
