//
//  TableViewCellTableViewCell.swift
//  Notific
//
//  Created by Дмитрий Пономарев on 20.04.2023.
//

import UIKit
import SnapKit

final class TableViewCell: UITableViewCell {
    
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //MARK: - UI properties
    
    let label = UILabel()
    
    
    //MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        contentView.backgroundColor = .systemBlue
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    public func configureView(_ model: String, selected: Bool) {
        label.text = model
        
        if selected {
            label.textColor = .red
        } else {
            label.textColor = .white
        }
    }
}

//MARK: - Private methods

private extension TableViewCell {
    
    //MARK: - Setup
    
    //TODO: setup UI
    
    func setup() {
        addViews()
        makeConstraints()
        setupViews()
    }
    
    //MARK: - addViews
    
    func addViews() {
        contentView.addSubview(label)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        label.snp.makeConstraints {
            
            $0.leading.equalToSuperview().inset(20)
            $0.top.bottom.equalToSuperview().inset(8)
        }
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        label.textColor = .white
    }
}
