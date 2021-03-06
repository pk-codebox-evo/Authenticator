//
//  TokenRowModel.swift
//  Authenticator
//
//  Copyright (c) 2015-2016 Authenticator authors
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import OneTimePassword

struct TokenRowModel: Equatable, Identifiable {
    typealias Action = TokenList.Action

    let name, issuer, password: String
    let showsButton: Bool
    let buttonAction: Action
    let selectAction: Action
    let editAction: Action
    let deleteAction: Action

    private let identifier: NSData

    init(persistentToken: PersistentToken, displayTime: DisplayTime) {
        name = persistentToken.token.name
        issuer = persistentToken.token.issuer
        let timeInterval = displayTime.timeIntervalSince1970
        password = (try? persistentToken.token.generator.passwordAtTime(timeInterval)) ?? ""
        if case .Counter = persistentToken.token.generator.factor {
            showsButton = true
        } else {
            showsButton = false
        }
        buttonAction = .UpdatePersistentToken(persistentToken)
        selectAction = .CopyPassword(password)
        editAction = .EditPersistentToken(persistentToken)
        deleteAction = .DeletePersistentToken(persistentToken)
        identifier = persistentToken.identifier
    }

    func hasSameIdentity(other: TokenRowModel) -> Bool {
        return self.identifier.isEqualToData(other.identifier)
    }
}

func == (lhs: TokenRowModel, rhs: TokenRowModel) -> Bool {
    return (lhs.name == rhs.name)
        && (lhs.issuer == rhs.issuer)
        && (lhs.password == rhs.password)
        && (lhs.showsButton == rhs.showsButton)
        && (lhs.buttonAction == rhs.buttonAction)
        && (lhs.selectAction == rhs.selectAction)
        && (lhs.editAction == rhs.editAction)
        && (lhs.deleteAction == rhs.deleteAction)
        && (lhs.identifier == rhs.identifier)
}
