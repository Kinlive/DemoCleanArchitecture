//
//  BaseAccessoryView.swift
//  MessageDemo
//
//  Created by Thinkpower on 2019/11/28.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

enum AccessoryViewTypes {
  case done
  case none
}

class BaseAccessoryView: UIView {

  typealias Completion = (Bool) -> Void

  // MARK: - All events define.
  struct Events {
    var onContentSizeChanged: ((CGSize) -> Void)?
  }

  // MARK: - All subviews constraint define.
  struct ConstraintsSet: LayoutConstraints {
    var topStack: NSLayoutConstraintSet = NSLayoutConstraintSet()
    var bottomStack: NSLayoutConstraintSet = NSLayoutConstraintSet()

    var all: [NSLayoutConstraintSet] {
      return [topStack, bottomStack]
    }
  }

  // MARK: - Subviews.
  public lazy var topStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.backgroundColor = .clear
    stackView.spacing = 0
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  public lazy var bottomStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.backgroundColor = .clear
    stackView.axis = .horizontal
    stackView.spacing = 0
    stackView.alignment = .leading
    stackView.distribution = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  // MARK: - AccessoryViews

  // MARK: - properties for output
  /// Store all events of subview's actions which be triggered.
  public var events: Events = Events()

  /// Store some constraints of all subviews that will be used.
  public var constraintsSet: ConstraintsSet = ConstraintsSet()

  /// first display accessoryView type set.
  public private(set) var accessoryTypes: AccessoryViewTypes = .done

  // MARK: - AccessoryInputView contentSize use.
  private lazy var cacheIntrinsicContentSize: CGSize = calculateSumIntrinsicSize()
  private var previousIntrinsicContentSize: CGSize = .zero
  override var intrinsicContentSize: CGSize {
    return cacheIntrinsicContentSize
  }

  // MARK: - Override
  override init(frame: CGRect) {
    super.init(frame: frame)
    autoresizingMask = .flexibleHeight
    addSubviews()
    setConstraints()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    autoresizingMask = .flexibleHeight
  }

  override func invalidateIntrinsicContentSize() {
    super.invalidateIntrinsicContentSize()
    cacheIntrinsicContentSize = calculateSumIntrinsicSize()
    if previousIntrinsicContentSize != cacheIntrinsicContentSize {
      // option add did bottom bar content changed
      events.onContentSizeChanged?(cacheIntrinsicContentSize)

      previousIntrinsicContentSize = cacheIntrinsicContentSize
    }
  }

  // when user tapped on the base view 'self' but it was empty that will skip then trigger viewcontroller's touch event.
  //  and others of self.subviews touch event still deliver.
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let result = super.hitTest(point, with: event)
    if result == self { return nil }
    return result
  }

  // MARK: - Default Setup
  private func addSubviews() {
    addSubview(topStackView)
    addSubview(bottomStackView)
  }

  private func setConstraints() {

    // topStackView's constraints.
    constraintsSet.topStack.top    = topStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
    constraintsSet.topStack.left   = topStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
    constraintsSet.topStack.right  = topStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
    constraintsSet.topStack.bottom = topStackView.bottomAnchor.constraint(equalTo: bottomStackView.topAnchor, constant: 0)

    // bottomStackView's constraints.
    constraintsSet.bottomStack.left   = bottomStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
    constraintsSet.bottomStack.bottom = bottomStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)
    constraintsSet.bottomStack.right  = bottomStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)

    // switch to safe area layout guide
    if #available(iOS 11.0, *) {
      constraintsSet.topStack.top = topStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)
      constraintsSet.topStack.left = topStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0)
      constraintsSet.topStack.right = topStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0)

      constraintsSet.bottomStack.left = bottomStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 0)
      constraintsSet.bottomStack.right = bottomStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: 0)
      constraintsSet.bottomStack.bottom = bottomStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: 0)
    }

    constraintsSet.activateAll()
  }

  // MARK: - Calculates.
  private func calculateSumIntrinsicSize() -> CGSize {
    return CGSize(width: UIView.noIntrinsicMetric,
                  height: calculateIntrinsicSizeOfBottomStackView() +
                          calculateIntrinsicSizeOfTopStackView())
  }

  private func calculateIntrinsicSizeOfTopStackView() -> CGFloat {
    return topStackView.arrangedSubviews.isEmpty ? 0 : topStackView.bounds.height
  }

  private func calculateIntrinsicSizeOfBottomStackView() -> CGFloat {
    var subviewsHeight: CGFloat = 0
    bottomStackView.arrangedSubviews.forEach {
        subviewsHeight += $0.bounds.height
    }
    return subviewsHeight
  }

  // MARK: - StackView actions.
  public private(set) var cacheTopView: UIView?
  private func removeTopStackSubviews() {
    cacheTopView = nil
    topStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    topStackView.layoutIfNeeded()
  }

  /// You can insert custom to top stackView on anytime, and it will immediate remove subview and insert new then relayout self.
  /// If need remove subviews just call it again without parameter.
  public func insertCustomToTopStackView(view: UIView? = nil, completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
        self.removeTopStackSubviews()
        if let view = view {
            self.cacheTopView = view
            self.topStackView.addArrangedSubview(view)
            self.topStackView.layoutIfNeeded()

        }
        self.invalidateIntrinsicContentSize()
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        completion?()
    }
  }

}


