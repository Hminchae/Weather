//
//  VerticalCollectionViewCell.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import UIKit

final class VerticalCollectionViewCell: BaseCollectionViewCell {
    
    private let dayOfWeekLabel = {
        let label = UILabel()
        label.font = WEFont.m14
        label.textColor = .white
        
        return label
    }()
    
    private let weatherIcon = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let minTempLabel = {
        let label = UILabel()
        label.font = WEFont.m14
        label.textColor = .white
        
        return label
    }()
    
    private let maxTempLabel = {
        let label = UILabel()
        label.font = WEFont.m14
        label.textColor = .white
        
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(dayOfWeekLabel)
        contentView.addSubview(weatherIcon)
        contentView.addSubview(minTempLabel)
        contentView.addSubview(maxTempLabel)
    }
    
    override func configureLayout() {
        dayOfWeekLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(4)
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(dayOfWeekLabel.snp.trailing).offset(8)
        }

        minTempLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(weatherIcon.snp.trailing).offset(4)
        }
        
        maxTempLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(minTempLabel.snp.trailing).offset(8)
        }
    }
    
    override func configureView() {
        
    }
    
    public func configure(dayOfWeek: String, icon: String, minTemp: Double, maxTemp: Double) {
        dayOfWeekLabel.text = dayOfWeek
        weatherIcon.kf.setImage(with: URL(string: "\(Constants.iconURL)\(icon)\(Constants.iconSize)"))
        minTempLabel.text = "\(minTemp)"
        maxTempLabel.text = "\(maxTemp)"
    }
}
