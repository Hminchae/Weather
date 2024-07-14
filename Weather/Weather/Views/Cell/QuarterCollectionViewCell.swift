//
//  QuarterCollectionViewCell.swift
//  Weather
//
//  Created by 황민채 on 7/15/24.
//

import UIKit

final class QuarterCollectionViewCell: BaseCollectionViewCell {
    
    private let titleLabel = {
        let label = UILabel()
        label.font = WEFont.m12
        label.textColor = .white
        
        return label
    }()
    
    private let BigLabel = {
        let label = UILabel()
        label.font = WEFont.b20
        label.textColor = .white
        
        return label
    }()
    
    override func configureHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(BigLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(5)
            make.height.equalTo(14)
        }
        
        BigLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(5)
            make.height.equalTo(22)
        }
    }
    
    override func configureView() {
        
    }
    
    public func configure(title: String, content: String) {
        titleLabel.text = title
        BigLabel.text = content
        // 옵셔널 텍스트는 나중에..
    }
}
