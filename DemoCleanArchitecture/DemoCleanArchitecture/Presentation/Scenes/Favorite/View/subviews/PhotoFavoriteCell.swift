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
    image.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.3)
    return image
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .black
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping

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
    subviewsConstraint.image.height = photoImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.95)
    subviewsConstraint.image.width = photoImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.95)
    subviewsConstraint.image.centerY = photoImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

    // title
    subviewsConstraint.title.left = titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15)
    subviewsConstraint.title.top = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
    subviewsConstraint.title.bottom = titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: contentView.bottomAnchor, constant: -5)
    subviewsConstraint.title.right = titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: photoImageView.leadingAnchor, constant: -10)

    subviewsConstraint.activateAll()
  }

  func configure(input: Input, output: Output) {
    self.input = input
    self.output = output

    titleLabel.text = input.photo.title

    let imageUrl = "https://farm\(input.photo.farm).staticflickr.com/\(input.photo.server ?? "")/\(input.photo.id)_\(input.photo.secret ?? "").jpg"
    photoImageView.downloaded(from: imageUrl)
  }

}
