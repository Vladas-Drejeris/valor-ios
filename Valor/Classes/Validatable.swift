//
//  Validatable.swift
//  Valor
//
//  Created by Vladas Drejeris on 06/03/2018.
//

import Foundation

public protocol Validatable {

    public func validated(by validators: Validator<Self>...) throws -> Valid<Self>
    public func validated(by validators: [Validator<Self>]) throws -> Valid<Self>

}

public extension Validatable {

    public func validated(by validators: Validator<Self>...) throws -> Valid<Self> {
        return try validated(by: validators)
    }

    public func validated(by validators: [Validator<Self>]) throws -> Valid<Self> {
        let validator = Validator(from: validators)
        try validator.validate(self)
        return Valid(value: self)
    }

}
