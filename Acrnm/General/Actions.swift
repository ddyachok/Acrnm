//
//  Actions.swift
//  Template
//
//  Created by NerdzLab
//

import Foundation
import UIKit

typealias EmptyAction = () -> Void
typealias BoolAction = (Bool) -> Void
typealias ErrorAction = (Error) -> Void
typealias TextAction = (String) -> Void
typealias OptionalTextAction = (String?) -> Void
typealias IntAction = (Int) -> Void
typealias IntArrayAction = ([Int]) -> Void
typealias OptionalIntAction = (Int?) -> Void
typealias DataAction = (Data) -> Void
typealias OptionalDataAction = (Data?) -> Void
typealias DateAction = (Date) -> Void
typealias OptionalDateAction = (Date?) -> Void
typealias DecimalAction = (Decimal) -> Void
typealias OptionalImageAction = (URL?) -> Void
typealias CGRectAction = (CGRect) -> Void
typealias TimeIntervalAction = (TimeInterval) -> Void
