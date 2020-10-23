//
//  FavoriteHeaderView.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/23.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit

extension FavoriteHeaderView {
  struct Input {
    let title: String
  }

  struct Output {
    let onTappedHeader: () -> Void
  }

  private struct Constraints: LayoutConstraints {
    let title = NSLayoutConstraintSet()

    var all: [NSLayoutConstraintSet] { [title] }
  }
}

class FavoriteHeaderView: UIView {

  // MARK: - Subviews
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  // MARK: - Properties
  private let subviewConstraints = Constraints()
  private var input: Input?
  private var output: Output?

  // MARK: - Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  convenience init(input: Input, output: Output) {
    self.init(frame: .zero)

    self.input = input
    self.output = output

    addSubviews()
    makeUIsBehavior()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    makeUIs()
    makeUIsConstraints()
  }

  // MARK: - Make UIs
  private func addSubviews() {
    addSubview(titleLabel)
  }

  private func makeUIsBehavior() {
    isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(recognizer:)))
    addGestureRecognizer(tap)
  }

  private func makeUIs() {
    backgroundColor = .lightGray
  }

  private func makeUIsConstraints() {
    subviewConstraints.title.centerY = titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    subviewConstraints.title.left = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)

    subviewConstraints.activateAll()
  }

  @objc private func tapGesture(recognizer: UITapGestureRecognizer) {
    print("On tapped header")
    output?.onTappedHeader()
  }

}
