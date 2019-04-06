//
//  BaseListCellModel.swift
//  Minerva
//
//  Created by Joe Laws
//  Copyright © 2019 Optimize Fitness, Inc. All rights reserved.
//

import Foundation
import UIKit

import IGListKit

open class BaseListCellModel: NSObject, ListCellModel {

  open override var description: String {
    return "[\(String(describing: type(of: self))) \(self.identifier)]"
  }

  // MARK: - ListCellModel
  public weak var cell: ListCollectionViewCell?

  open var usesNib: Bool {
    return false
  }
  open var reorderable: Bool {
    return false
  }
  open var identifier: String {
    let identifier = String(describing: Unmanaged.passUnretained(self).toOpaque())
    guard !identifier.isEmpty else {
      assertionFailure("The identifier should exist for \(self)")
      return UUID().uuidString
    }
    return identifier
  }
  open func isEqual(to model: ListCellModel) -> Bool {
    return self === model
  }
  open func size(constrainedTo containerSize: CGSize) -> CGSize? {
    return nil
  }

  // MARK: - ListDiffable
  public final func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let model = object as? BaseListCellModel else {
      return false
    }
    return isEqual(to: model)
  }

  public final func diffIdentifier() -> NSObjectProtocol {
    return identifier as NSString
  }
}