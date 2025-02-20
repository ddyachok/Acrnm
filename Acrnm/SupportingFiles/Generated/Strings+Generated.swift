// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {
  /// ACRONYM®
  internal static let acronymCopyright = L10n.tr("Localizable", "ACRONYM_COPYRIGHT", fallback: "ACRONYM®")
  /// Localizable.strings
  ///   Template
  /// 
  ///   Created by Yuriy on 21.09.2022.
  internal static let appTitle = L10n.tr("Localizable", "APP_TITLE", fallback: "Acrnm")
  /// SS24 COLLECTION
  internal static let collectionS24 = L10n.tr("Localizable", "COLLECTION_S24", fallback: "SS24 COLLECTION")
  /// VIEW COLLECTION
  internal static let homeViewCollection = L10n.tr("Localizable", "HOME_VIEW_COLLECTION", fallback: "VIEW COLLECTION")
  /// UNIT
  internal static let productsCollectionUnit = L10n.tr("Localizable", "PRODUCTS_COLLECTION_UNIT", fallback: "UNIT")
  /// Home
  internal static let tabBarHomeTitle = L10n.tr("Localizable", "TAB_BAR_HOME_TITLE", fallback: "Home")
  /// Items
  internal static let tabBarItemsTitle = L10n.tr("Localizable", "TAB_BAR_ITEMS_TITLE", fallback: "Items")
  /// Saved Items
  internal static let tabBarSavedItemsTitle = L10n.tr("Localizable", "TAB_BAR_SAVED_ITEMS_TITLE", fallback: "Saved Items")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
