//
//  MockURLSession.swift
//  WallaMarvelData
//
//  Created by Fatma Anwar on 18/06/2025.
//

import Foundation

final class URLProtocolMock: URLProtocol {
    private static let queue = DispatchQueue(label: "URLProtocolMock.queue")
    nonisolated(unsafe) private static var _testData: Data?
    nonisolated(unsafe) private static var _testError: Error?
    
    static func setTestData(_ data: Data?) {
        queue.sync {
            _testData = data
            _testError = nil
        }
    }
    
    static func setTestError(_ error: Error?) {
        queue.sync {
            _testError = error
            _testData = nil
        }
    }
    
    private static func getTestData() -> Data? {
        queue.sync { _testData }
    }
    
    private static func getTestError() -> Error? {
        queue.sync { _testError }
    }
    
    override class func canInit(with request: URLRequest) -> Bool { true }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    
    override func startLoading() {
        if let error = Self.getTestError() {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let data = Self.getTestData() {
            client?.urlProtocol(self, didLoad: data)
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
