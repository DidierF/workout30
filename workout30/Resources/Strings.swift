// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum L10n {

  internal enum Exercise {
    /// Exercise
    internal static let exercise = L10n.tr("Localizable", "exercise.exercise")
    /// Rest
    internal static let rest = L10n.tr("Localizable", "exercise.rest")
    /// %02d:%02d
    internal static func timer(_ p1: Int, _ p2: Int) -> String {
      return L10n.tr("Localizable", "exercise.timer", p1, p2)
    }
  }

  internal enum Workout {
    /// Workout
    internal static let title = L10n.tr("Localizable", "workout.title")
    internal enum Button {
      /// Auto
      internal static let auto = L10n.tr("Localizable", "workout.button.auto")
      /// Finish
      internal static let finish = L10n.tr("Localizable", "workout.button.finish")
      /// Next
      internal static let next = L10n.tr("Localizable", "workout.button.next")
      /// Rest
      internal static let rest = L10n.tr("Localizable", "workout.button.rest")
      /// Start
      internal static let start = L10n.tr("Localizable", "workout.button.start")
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
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
