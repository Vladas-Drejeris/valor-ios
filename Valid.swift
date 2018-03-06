//
//  Valid.swift
//  Valor
//
//  Created by Vladas Drejeris on 06/03/2018.
//

import Foundation

public struct Valid<Output> {

    public var value: Output
}

public extension Valid where Output: Validatable {

    public func validated(by validators: Validator<Output>...) throws -> Valid<Output> {
        return try value.validated(by: validators)
    }

    public func validated(by validators: [Validator<Output>]) throws -> Valid<Output> {
        return try value.validated(by: validators)
    }

}
