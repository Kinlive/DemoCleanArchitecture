//
//  FavoriteHeaderView.swift
//  DemoCleanArchitecture
//
//  Created by KinWei on 2020/10/23.
//  Copyright © 2020 KinWei. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

extension FavoriteHeaderView {
  struct Input {
    let title: String
    let section: Int
    let isExpand: Bool
  }

  struct Output {
    let onTappedHeader: (_ isExpanding: Bool, _ section: Int) -> Void
  }

  private struct Constraints: LayoutConstraints {
    let title = NSLayoutConstraintSet()
    var tappedSpace = NSLayoutConstraintSet()

    var all: [NSLayoutConstraintSet] { [title, tappedSpace] }
  }
}

class FavoriteHeaderView: UITableViewHeaderFooterView {

  var bag = DisposeBag()

  // MARK: - Subviews
//  lazy var titleLabel: UILabel = {
//    let label = UILabel()
//    label.translatesAutoresizingMaskIntoConstraints = false
//    label.textColor = .black
//    return label
//  }()

    lazy var tappedButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(tapGesture(recognizer:)), for: .touchUpInside)
        return btn
    }()

  // MARK: - Properties
  private let subviewConstraints = Constraints()
  private var input: Input?
  private var output: Output?
  private var isExpanding: Bool = true

  // MARK: - Initialize
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    addSubviews()
    makeUIsBehavior()

  }

  override func prepareForReuse() {
    super.prepareForReuse()

    bag = DisposeBag()
  }

  public func configure(input: Input, output: Output) {
    self.input = input
    self.output = output
    configure()
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
    //addSubview(titleLabel)
    contentView.addSubview(tappedButton)
  }

  private func makeUIsBehavior() {
    isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(tapGesture(recognizer:)))
    contentView.addGestureRecognizer(tap)
  }

  private func makeUIs() {
    //backgroundColor = .lightGray
    let colorView = UIView()
    colorView.backgroundColor = .lightGray
    backgroundView = colorView
  }

  private func makeUIsConstraints() {
//    subviewConstraints.title.centerY = titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//    subviewConstraints.title.left = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)

    subviewConstraints.tappedSpace.top = tappedButton.topAnchor.constraint(equalTo: contentView.topAnchor)
    subviewConstraints.tappedSpace.left = tappedButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
    subviewConstraints.tappedSpace.right = tappedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    subviewConstraints.tappedSpace.bottom = tappedButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

    subviewConstraints.activateAll()
  }

  @objc private func tapGesture(recognizer: UITapGestureRecognizer) {
    isExpanding.toggle()
    let toggled = isExpanding
    output?.onTappedHeader(toggled, input?.section ?? 1)
  }

  private func configure() {
    self.textLabel?.text = input?.title
    self.isExpanding = input?.isExpand ?? true
   // titleLabel.text = input?.title
  }
}
