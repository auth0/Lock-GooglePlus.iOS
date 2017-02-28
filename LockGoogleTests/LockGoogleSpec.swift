// LockGoogleSpec.swift
//
// Copyright (c) 2017 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Quick
import Nimble
import Auth0
@testable import LockGoogle

class LockGoogleSpec: QuickSpec {

    override func spec() {

        let authentication = Auth0.authentication(clientId: "CLIENT_ID", domain: "samples.auth0.com")

        describe("init") {
            var lockGoogle: LockGoogle?

            beforeEach {
                lockGoogle = nil
            }

            it("should init with authentication") {
                lockGoogle = LockGoogle(client: "220613544498-ht0o1oon3259e86jtfmn3td36c497i76.apps.googleusercontent.com")
                expect(lockGoogle).toNot(beNil())
            }
        }

        describe("login") {
            var lockGoogle: LockGoogle!
            var transaction: NativeAuthTransaction?

            beforeEach {
                lockGoogle = LockGoogle(client: "220613544498-ht0o1oon3259e86jtfmn3td36c497i76.apps.googleusercontent.com", authentication: authentication)
                transaction = nil
            }

            it("should return a transaction") {
                transaction = lockGoogle.login(withConnection: "", scope: "", parameters: [:])
                expect(transaction).toNot(beNil())
            }

            it("should return a transaction with connection name") {
                transaction = lockGoogle.login(withConnection: "google-oauth2", scope: "", parameters: [:])
                expect(transaction!.connection) == "google-oauth2"
            }

            it("should return a transaction with scope openid profile") {
                transaction = lockGoogle.login(withConnection: "google-oauth2", scope: "openid profile", parameters: [:])
                expect(transaction!.scope) == "openid profile"
            }

            it("should return a transaction with custom parameters") {
                transaction = lockGoogle.login(withConnection: "google-oauth2", scope: "openid profile", parameters: ["param1": "value1"])
                let value = transaction!.parameters["param1"] as! String
                expect(value) == "value1"
            }

            it("should use specified authentication object") {
                transaction = lockGoogle.login(withConnection: "google-oauth2", scope: "openid profile", parameters: ["param1": "value1"])
                expect(transaction!.authentication.clientId) == authentication.clientId
            }
        }
    }
}
