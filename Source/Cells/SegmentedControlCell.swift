//
//  Copyright © 2019 Optimize Fitness, Inc. All rights reserved.
//

import UIKit

open class SegmentedControlCellModel: BaseListCellModel {
  public typealias Action = (SegmentedControlCellModel, UISegmentedControl) -> Void

  public var backgroundColor: UIColor?
  public var switchedSegmentAction: Action?
  public var titleFont = UIFont.preferredFont(forTextStyle: .subheadline)
  public var tintColor: UIColor?

  fileprivate var selectedSegment: Int
  fileprivate let segmentTitles: [String]

  public init(selectedSegment: Int, segmentTitles: [String]) {
    self.segmentTitles = segmentTitles
    self.selectedSegment = selectedSegment
    super.init()
  }

  // MARK: - BaseListCellModel

  override open var identifier: String { "SegmentedControlCellModel" }

  override open func identical(to model: ListCellModel) -> Bool {
    guard let model = model as? Self, super.identical(to: model) else { return false }
    return segmentTitles == model.segmentTitles
      && titleFont == model.titleFont
      && tintColor == model.tintColor
      && selectedSegment == model.selectedSegment
      && backgroundColor == model.backgroundColor
  }
}

public final class SegmentedControlCell: BaseListCell<SegmentedControlCellModel> {

  private let segmentedControl = UISegmentedControl(frame: .zero)

  override public init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(segmentedControl)
    backgroundView = UIView()
    setupConstraints()
  }

  @objc
  private func pressedSegmentedControl(_ sender: UISegmentedControl) {
    guard let model = self.model else {
      return
    }
    model.selectedSegment = sender.selectedSegmentIndex
    model.switchedSegmentAction?(model, sender)
  }

  // MARK: - BaseListCell

  override public func bind(model: SegmentedControlCellModel, sizing: Bool) {
    super.bind(model: model, sizing: sizing)

    segmentedControl.removeAllSegments()
    for (index, title) in model.segmentTitles.enumerated() {
      segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
    }
    segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: model.titleFont], for: .normal)

    guard !sizing else { return }

    segmentedControl.tintColor = model.tintColor
    segmentedControl.selectedSegmentIndex = model.selectedSegment
    backgroundView?.backgroundColor = model.backgroundColor
  }
}

// MARK: - Constraints
extension SegmentedControlCell {
  private func setupConstraints() {

    segmentedControl.anchorTo(layoutGuide: contentView.layoutMarginsGuide)
    self.segmentedControl.addTarget(
      self,
      action: #selector(pressedSegmentedControl),
      for: .valueChanged
    )

    contentView.shouldTranslateAutoresizingMaskIntoConstraints(false)
  }
}