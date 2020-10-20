//
//  SearchRecordCell.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/19.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

// MARK: - Input & Output & Constraints declare
extension SearchRecordCell {
  struct Input {
    var recordQuery: PhotosQuery
    var indexPath: IndexPath
  }

  struct Output {

  }

  struct Constraints: LayoutConstraints {
    let title: NSLayoutConstraintSet = NSLayoutConstraintSet()
    let lastTime: NSLayoutConstraintSet = NSLayoutConstraintSet()

    var all: [NSLayoutConstraintSet] { [title, lastTime] }
  }
}

class SearchRecordCell: UITableViewCell {

  // MARK: - Subviews
  lazy var titleLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .darkGray
    return label
  }()

  lazy var lastTimeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .lightGray
    label.font = .systemFont(ofSize: 12)
    return label
  }()

  lazy var selectedColorView: UIView = {
    let view = UIView(frame: .zero)
    view.backgroundColor = UIColor.green.withAlphaComponent(0.5)
    return view
  }()

  // MARK: -  Properties
  private var input: Input?
  private var output: Output?
  private let subviewsConstraints: Constraints = Constraints()

  // MARK: - Initialize
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: String(describing: type(of: self)))

    selectedBackgroundView = selectedColorView
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    makeUIsConstraints()
  }

  // MARK: - UI setup
  private func addSubviews() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(lastTimeLabel)
  }

  private func makeUIsConstraints() {

    subviewsConstraints.title.left = titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
    subviewsConstraints.title.right = titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -20)
    subviewsConstraints.title.centerY = titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

    subviewsConstraints.lastTime.right = lastTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
    subviewsConstraints.lastTime.bottom = lastTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)

    subviewsConstraints.activateAll()
  }

  public func configure(with input: Input, and output: Output) {
    self.input = input
    self.output = output

    setupUIs()
  }

  private func setupUIs() {
    titleLabel.text = input?.recordQuery.searchText
    lastTimeLabel.text = convertDate(query: input?.recordQuery)
  }

  private func convertDate(query: PhotosQuery?) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm"
    guard let createDate = query?.createDate else { return "" }

    let date = formatter.string(from: createDate)

    return "上次搜尋 \(date)"
  }
}
