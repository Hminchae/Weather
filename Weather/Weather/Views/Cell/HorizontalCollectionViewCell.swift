//
//  HorizontalCollectionViewCell.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import UIKit

import Kingfisher

final class HorizontalCollectionViewCell: BaseCollectionViewCell {
    
    private let hourLabel = {
        let label = UILabel()
        label.font = WEFont.r13
        label.textColor = .white
        
        return label
    }()
    
    private let weatherIcon = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let tempLabel = {
        let label = UILabel()
        label.font = WEFont.m14
        label.textColor = .white
        
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(hourLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(tempLabel)
    }
    
    override func configureLayout() {
        hourLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(4)
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hourLabel.snp.bottom).offset(4)
            make.size.equalTo(25)
        }

        tempLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(weatherIcon.snp.bottom).offset(4)
        }
    }
    
    override func configureView() {
        
    }
    
    public func configure(hour: String, icon: String, temp: Double) {
        hourLabel.text = hour
        let url = URL(string: "\(Constants.iconURL)\(icon)@\(Constants.iconSize)")
        print(url)
        weatherIcon.kf.setImage(with: url)
        tempLabel.text = String(Int(temp))
    }
}
