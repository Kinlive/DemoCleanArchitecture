//
//  PhotosResultCell.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/20.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

extension PhotosResultCell {
  struct Input {
    var photo: Photo
    var indexPath: IndexPath
    var wasFavorite: Bool
  }

  struct Output {
    var onFavoriteSelected: ((Input) -> Void)?
    var onFavoriteCanceled: ((Input) -> Void)?
  }

  private struct Constraints: LayoutConstraints {
    let photo = NSLayoutConstraintSet()
    let titleBase = NSLayoutConstraintSet()
    let title = NSLayoutConstraintSet()
    let favorite = NSLayoutConstraintSet()

    var all: [NSLayoutConstraintSet] { [photo, titleBase, title, favorite] }
  }
}

class PhotosResultCell: UICollectionViewCell {

  // MARK: - Subviews
  lazy var photoImageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleToFill
    return image
  }()

  lazy var titleBaseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .white

    return label
  }()

  lazy var favoriteButton: UIButton = {
    let btn = UIButton()
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.addTarget(self, action: #selector(onFavoriteTapped(sender:)), for: .touchUpInside)
    btn.setImage(UIImage(named: "addFavorite"), for: .normal)
    btn.setImage(UIImage(named: "favorited"), for: .selected)

    return btn
  }()

  // MARK: - Properties
  private var input: Input?
  private var output: Output?
  private var subviewsConstraints = Constraints()

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubviews()

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    photoImageView.image = nil
    favoriteButton.isSelected = false
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    makeUIsConstraints()
  }

  // MARK: - Make UIs
  private func addSubviews() {
    contentView.addSubview(photoImageView)
    contentView.addSubview(titleBaseView)
    contentView.addSubview(favoriteButton)
    contentView.addSubview(titleLabel)
  }

  private func makeUIsConstraints() {
    subviewsConstraints.deactivateAll()

    // Photo
    subviewsConstraints.photo.top = photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
    subviewsConstraints.photo.left = photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10)
    subviewsConstraints.photo.right = photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
    subviewsConstraints.photo.bottom = photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)

    // Title base view
    subviewsConstraints.titleBase.left = titleBaseView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
    subviewsConstraints.titleBase.right = titleBaseView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    subviewsConstraints.titleBase.bottom = titleBaseView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    subviewsConstraints.titleBase.height = titleBaseView.heightAnchor.constraint(equalToConstant: 40)

    // title
    subviewsConstraints.title.centerX = titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
    subviewsConstraints.title.top = titleLabel.topAnchor.constraint(equalTo: titleBaseView.topAnchor, constant: 10)
    subviewsConstraints.title.bottom = titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: titleBaseView.bottomAnchor, constant: 5)

    // favorite button
    subviewsConstraints.favorite.top = favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
    subviewsConstraints.favorite.right = favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
    subviewsConstraints.favorite.width = favoriteButton.widthAnchor.constraint(equalToConstant: 30)
    subviewsConstraints.favorite.height = favoriteButton.heightAnchor.constraint(equalToConstant: 30)

    subviewsConstraints.activateAll()
  }

  // MARK: - Configures.
  func configure(input: Input, output: Output) {
    self.input = input
    self.output = output

    titleLabel.text = input.photo.title

    let imageUrl = "https://farm\(input.photo.farm).staticflickr.com/\(input.photo.server ?? "")/\(input.photo.id)_\(input.photo.secret ?? "").jpg"
    //print(imageUrl)
    photoImageView.downloaded(from: imageUrl)

    favoriteButton.isSelected = input.wasFavorite

  }

  @objc private func onFavoriteTapped(sender: UIButton) {
    guard let input = input else { return }

    switch sender.isSelected {
    case true: output?.onFavoriteCanceled?(input)
    case false: output?.onFavoriteSelected?(input)
    }

  }

}
