//
//  StringValidation.swift
//  Valor
//
//  Created by Vladas Drejeris on 06/03/2018.
//

import Foundation

public enum StringValidationError: Error {

    case nonAlphanumericCharacters
    case nonDecimalDigitCharacters
    case invalidCharacters
    case invalidCharacterCount
    case tooFewCharacters
    case tooManyCharacters
    case notEqual
    case empty
    case notEmpty
    case invalidString

}


extension String : Validatable {

}

public extension Validator where Input == String {

    static func noCharacters(_ characterSet: CharacterSet,
                                     _ error: Error) -> Validator<Input> {
        return Validator { input in
            guard input.rangeOfCharacter(from: characterSet) == nil else {
                throw error
            }
        }
    }


    public static func noCharacters(_ characterSet: CharacterSet) -> Validator<Input> {
        return noCharacters(characterSet, StringValidationError.invalidCharacters)
    }

    public static func characters(_ characterSet: CharacterSet) -> Validator<Input> {
        return noCharacters(characterSet.inverted, StringValidationError.invalidCharacters)
    }

    public static func alphanumeric() -> Validator<Input> {
        return noCharacters(CharacterSet.alphanumerics.inverted, StringValidationError.nonAlphanumericCharacters)
    }

    public static func decimalDigits() -> Validator<Input> {
        return noCharacters(CharacterSet.decimalDigits.inverted, StringValidationError.nonDecimalDigitCharacters)
    }

    public static func empty() -> Validator<Input> {
        return Validator { input in
            guard input.isEmpty == true else {
                throw StringValidationError.notEmpty
            }
        }
    }

    public static func notEmpty() -> Validator<Input> {
        return Validator { input in
            guard input.isEmpty == false else {
                throw StringValidationError.empty
            }
        }
    }

    public private static func count(_ op: @escaping (Int, Int) -> Bool,
                              _ requirement: Int,
                              _ error: Error) -> Validator<Input> {
        return Validator { input in
            guard op(input.count, requirement) == true else {
                throw error
            }
        }
    }

    public static func count(_ op: @escaping (Int, Int) -> Bool,
                      _ requirement: Int) -> Validator<Input> {
        return count(op, requirement, StringValidationError.invalidCharacterCount)
    }

    public static func count(moreThan requirement: Int) -> Validator<Input> {
        return count(>, requirement, StringValidationError.tooFewCharacters)
    }

    public static func count(lessThan requirement: Int) -> Validator<Input> {
        return count(<, requirement, StringValidationError.tooManyCharacters)
    }

    public static func equals(_ to: Input) -> Validator<Input> {
        return Validator.operation(==, to, error: StringValidationError.notEqual)
    }

    public static func regex(_ requirement: String) -> Validator<Input> {
        return Validator { input in
            let predicate = NSPredicate(format: "SELF MATCHES %@", requirement)
            guard predicate.evaluate(with: input) == true else {
                throw StringValidationError.invalidString
            }
        }
    }

}
