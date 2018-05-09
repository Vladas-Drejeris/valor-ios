//
//  Validator.swift
//  Valor
//
//  Created by Vladas Drejeris on 06/03/2018.
//

import Foundation

public struct Validator<Input> {

    public var validate: (Input) throws -> ()

    public init(validate: @escaping (Input) throws -> ()) {
        self.validate = validate
    }
}

public extension Validator {

    public init(from validators: Validator<Input>...) {
        self.init(from: validators)
    }

    public init(from validators: [Validator<Input>]) {
        let validate = { (input: Input) in
            try validators.forEach { try $0.validate(input) }
        }
        self.init(validate: validate)
    }

}

// MARK: - Generic validator for external operations

public extension Validator {

    public static func operation(_ op: @escaping (Input, Input) -> Bool,
                          _ requirement: Input,
                          error: Error) -> Validator<Input> {
        return Validator { input in
            if !op(input, requirement) {
                throw error
            }
        }
    }

}
