//
//  EditPostView.swift
//  POSTR
//
//  Created by Luis Calle on 1/31/18.
//  Copyright © 2018 On-The-Line. All rights reserved.
//

import UIKit

class EditPostView: UIView {
    
    lazy var topContainer: UIView = {
        let tc = UIView()
        return tc
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Post"
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        return label
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "checkmark"), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    lazy var captionTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.text = "Insert caption here"
        textView.textAlignment = .left
        textView.autocapitalizationType = .sentences
        textView.autocorrectionType = .yes
        textView.font = UIFont.systemFont(ofSize: 20, weight: .medium
        )
        //textView.backgroundColor = .orange
        return textView
    }()
    
    lazy var selectImageButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "placeholderImage"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    lazy var selectCategoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Select a category:"
        return label
    }()
    
    lazy var categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoriesCell.self, forCellReuseIdentifier: "categoryCell")
        return tableView
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        setupViews()
    }
    
    public func configureEditPost(post: Post) {
        captionTextView.text = post.caption
    }
    
    private func setupViews() {
        setupTopContainer()
        setupCancelButton()
        setupSubmitButton()
        setupHeaderLabel()
        setupCaptionTextView()
        setupImageButton()
        setupCategoryLabel()
        setupCategoryTableView()
    }
    
    private func setupTopContainer() {
        addSubview(topContainer)
        topContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            topContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            topContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            topContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.08)
            ])
    }
    
    private func setupCancelButton() {
        addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.leadingAnchor.constraint(equalTo: topContainer.leadingAnchor, constant: 10),
            cancelButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor)
            ])
    }
    
    private func setupSubmitButton() {
        addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.trailingAnchor.constraint(equalTo: topContainer.trailingAnchor, constant: -10),
            submitButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor)
            ])
    }
    
    private func setupHeaderLabel() {
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor)
            ])
        
    }
    
    private func setupCaptionTextView() {
        addSubview(captionTextView)
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            captionTextView.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 10),
            captionTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 30),
            captionTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -30),
            captionTextView.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            captionTextView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.08)
            ])
    }
    
    private func setupImageButton() {
        addSubview(selectImageButton)
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectImageButton.topAnchor.constraint(equalTo: captionTextView.bottomAnchor, constant: 5),
            selectImageButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            selectImageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            selectImageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            selectImageButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            ])
    }
    
    private func setupCategoryLabel() {
			addSubview(selectCategoryLabel)
			selectCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				selectCategoryLabel.topAnchor.constraint(equalTo: selectImageButton.bottomAnchor, constant: 5),
				selectCategoryLabel.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
				selectCategoryLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.05),
				selectCategoryLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
            ])
    }
    
    private func setupCategoryTableView() {
        addSubview(categoriesTableView)
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoriesTableView.topAnchor.constraint(equalTo: selectCategoryLabel.bottomAnchor, constant: 10),
            categoriesTableView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            categoriesTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            categoriesTableView.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
    }
    
}

