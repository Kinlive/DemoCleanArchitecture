//
//  PhotoFavoriteCell.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/23.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

extension PhotoFavoriteCell {
  struct Input {
    let indexPath: IndexPath
    let photo: Photo
  }

  struct Output {

  }

  private struct Constraints: LayoutConstraints {
    let image = NSLayoutConstraintSet()
    let title = NSLayoutConstraintSet()

    var all: [NSLayoutConstraintSet] { [image, title] }
  }
}

class PhotoFavoriteCell: UITableViewCell {

  // MARK: - Subviews
  lazy var photoImageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleToFill
    image.backgroundColor = .systemIndigo
    return image
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.numberOfLines = 0

    return label
  }()

  // MARK: - Properties
  private var input: Input?
  private var output: Output?
  private let subviewsConstraint: Constraints = Constraints()

  // MARK: - Initialize
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubviews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    makeUIsConstraint()
  }

  // MARK: - Make UIs
  private func addSubviews() {
    contentView.addSubview(photoImageView)
    contentView.addSubview(titleLabel)

  }
  private func makeUIsConstraint() {
    // image
    subviewsConstraint.image.right = photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
    subviewsConstraint.image.height = photoImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1)
    subviewsConstraint.image.width = photoImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1)
    subviewsConstraint.image.centerY = photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

    // title
    subviewsConstraint.title.left = titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
    subviewsConstraint.title.centerY = titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
    subviewsConstraint.title.right = titleLabel.trailingAnchor.constraint(greaterThanOrEqualTo: photoImageView.leadingAnchor, constant: 10)

    subviewsConstraint.activateAll()
  }

  func configure(input: Input, output: Output) {
    self.input = input
    self.output = output

    titleLabel.text = input.photo.title

  }

}
