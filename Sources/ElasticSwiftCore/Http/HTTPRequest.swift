//
//  HTTPRequest.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 6/16/19.
//

import Foundation
import Logging
import NIOHTTP1

// MARK: - HTTPRequest

/// Represents a HTTP request for Elasticsearch
public struct HTTPRequest {
    public let version: HTTPVersion
    public let method: HTTPMethod
    public let headers: HTTPHeaders
    public let body: Data?
    public let path: String
    public let queryParams: [URLQueryItem]

    public init(path: String, method: HTTPMethod, queryParams: [URLQueryItem] = [], headers: HTTPHeaders = HTTPHeaders(), body: Data? = nil) {
        version = HTTPVersion(major: 1, minor: 1)
        self.method = method
        self.body = body
        self.headers = headers
        self.path = path
        self.queryParams = queryParams
    }

    internal init(withBuilder builder: HTTPRequestBuilder) throws {
        guard builder.method != nil else {
            throw HTTPRequestBuilderError("method can't be nil")
        }

        guard builder.path != nil else {
            throw HTTPRequestBuilderError("url can't be nil")
        }

        if let version = builder.version {
            self.version = version
        } else {
            version = HTTPVersion(major: 1, minor: 1)
        }
        if let queryParams = builder.queryParams {
            self.queryParams = queryParams
        } else {
            queryParams = []
        }
        if let headers = builder.headers {
            self.headers = headers
        } else {
            headers = HTTPHeaders()
        }
        body = builder.body
        method = builder.method!
        path = builder.path!
    }

    public var query: String {
        if queryParams.isEmpty {
            return ""
        } else {
            return "?" + queryParams.map { $0.name + "=" + ($0.value ?? "") }.joined(separator: "&")
        }
    }

    public var pathWitQuery: String {
        return path + query
    }
}

extension HTTPRequest: Equatable {}

// MARK: - HTTPReqeustBuilder

/// Builder for `HTTPRequest`
public class HTTPRequestBuilder {
    private var _version: HTTPVersion?
    private var _method: HTTPMethod?
    private var _headers: HTTPHeaders?
    private var _body: Data?
    private var _path: String?
    private var _queryParams: [URLQueryItem]?
    private var _completionHandler: ((_ response: HTTPResponse) -> Void)?

    public init() {}

    @discardableResult
    public func set(version: HTTPVersion) -> HTTPRequestBuilder {
        _version = version
        return self
    }

    @discardableResult
    public func set(method: HTTPMethod) -> HTTPRequestBuilder {
        _method = method
        return self
    }

    @discardableResult
    public func set(headers: HTTPHeaders) -> HTTPRequestBuilder {
        _headers = headers
        return self
    }

    @discardableResult
    public func set(body: Data) -> HTTPRequestBuilder {
        _body = body
        return self
    }

    @discardableResult
    public func set(path: String) -> HTTPRequestBuilder {
        _path = path
        return self
    }

    @discardableResult
    public func set(queryParams: [URLQueryItem]) -> HTTPRequestBuilder {
        _queryParams = queryParams
        return self
    }

    @discardableResult
    public func set(completionHandler: @escaping ((_ response: HTTPResponse) -> Void)) -> HTTPRequestBuilder {
        _completionHandler = completionHandler
        return self
    }

    public var version: HTTPVersion? {
        return _version
    }

    public var method: HTTPMethod? {
        return _method
    }

    public var headers: HTTPHeaders? {
        return _headers
    }

    public var body: Data? {
        return _body
    }

    public var path: String? {
        return _path
    }

    public var queryParams: [URLQueryItem]? {
        return _queryParams
    }

    public var completionHandler: ((_ response: HTTPResponse) -> Void)? {
        return self._completionHandler
    }

    public func build() throws -> HTTPRequest {
        return try HTTPRequest(withBuilder: self)
    }
}
