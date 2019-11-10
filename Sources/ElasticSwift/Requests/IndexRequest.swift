//
//  index.swift
//  ElasticSwift
//
//  Created by Prafull Kumar Soni on 5/30/17.
//
//

import Foundation
import NIOHTTP1
import ElasticSwiftCore

//MARK:- Index Requet Builder

public class IndexRequestBuilder<T: Codable>: RequestBuilder where T: Equatable {
    
    public typealias RequestType = IndexRequest<T>
    
    private var _index: String?
    private var _type: String?
    private var _id: String?
    private var _source: T?
    private var _routing: String?
    private var _parent: String?
    private var _version: String?
    private var _versionType: VersionType?
    private var _refresh: IndexRefresh?
    
    public init() {}
    
    @discardableResult
    public func set(index: String) -> Self {
        self._index = index
        return self
    }
    
    @discardableResult
    @available(*, deprecated, message: "Elasticsearch has deprecated use of custom types and will be remove in 7.0")
    public func set(type: String) -> Self {
        self._type = type
        return self
    }
    
    @discardableResult
    public func set(id: String) -> Self {
        self._id = id
        return self
    }
    
    @discardableResult
    public func set(routing: String) -> Self {
        self._routing = routing
        return self
    }
    
    @discardableResult
    public func set(parent: String) -> Self {
        self._parent = parent
        return self
    }
    
    @discardableResult
    public func set(source: T) -> Self {
        self._source = source
        return self
    }
    
    @discardableResult
    public func set(version: String) -> Self {
        self._version = version
        return self
    }
    
    @discardableResult
    public func set(versionType: VersionType) -> Self {
        self._versionType = versionType
        return self
    }
    
    @discardableResult
    public func set(refresh: IndexRefresh) -> Self {
        self._refresh = refresh
        return self
    }
    
    public var index: String? {
        return self._index
    }
    public var type: String? {
        return self._type
    }
    public var id: String? {
        return self._id
    }
    public var source: T? {
        return self._source
    }
    public var routing: String? {
        return self._routing
    }
    public var parent: String? {
        return self._parent
    }
    public var version: String? {
        return self._version
    }
    public var versionType: VersionType? {
        return self._versionType
    }
    public var refresh: IndexRefresh? {
        return self._refresh
    }
    
    public func build() throws -> IndexRequest<T> {
        return try IndexRequest<T>(withBuilder: self)
    }
    
}

//MARK:- Index Request

public struct IndexRequest<T: Codable>: Request, BulkableRequest where T: Equatable {
    
    public var headers: HTTPHeaders = HTTPHeaders()
    
    public var method: HTTPMethod  {
        get {
            if self.id == "ID WILL BE GENERATED BY ELASTICSEARCH" {
                return .POST
            }
            return .PUT
        }
    }
    
    public let index: String
    public let type: String
    public let id: String
    public let source: T
    public var opType: OpType = .index
    public var routing: String?
    public var parent: String?
    public var version: String?
    public var versionType: VersionType?
    public var refresh: IndexRefresh?
    
    public init(index: String, type: String = "_doc", id: String?, source: T) {
        self.index = index
        self.type = type
        self.id = id ?? "ID WILL BE GENERATED BY ELASTICSEARCH"
        self.source = source
    }
    
    public init(index: String, type: String = "_doc", id: String?, source: T, routing: String?, parent: String?, refresh: IndexRefresh?, version: String, versionType: VersionType) {
        
        self.init(index: index, type: type, id: id, source: source)
        
        self.routing = routing
        self.parent = parent
        self.refresh = refresh
        self.version = version
        self.versionType = versionType
    }
    
    internal init(withBuilder builder: IndexRequestBuilder<T>) throws {
        
        guard builder.index != nil else {
            throw RequestBuilderError.missingRequiredField("index")
        }
        
        guard builder.source != nil else {
            throw RequestBuilderError.missingRequiredField("source")
        }
        
        guard (builder.version != nil && builder.versionType != nil) || (builder.version == nil && builder.versionType == nil) else {
            throw RequestBuilderError.missingRequiredField("source")
        }
        
        self.init(index: builder.index!, type: builder.type ?? "_doc", id: builder.id, source: builder.source!)
        
        self.routing = builder.routing
        self.parent = builder.parent
        self.version = builder.version
        self.versionType = builder.versionType
        self.refresh = builder.refresh
    }
    
    public var endPoint: String {
        get {
            var _endPoint = self.index + "/" + type
            if self.id != "ID WILL BE GENERATED BY ELASTICSEARCH" {
                _endPoint = _endPoint + "/" + id
            }
            return _endPoint
        }
    }
    
    public func makeBody(_ serializer: Serializer) -> Result<Data, MakeBodyError> {
        return serializer.encode(self.source).flatMapError { error in return .failure(.wrapped(error)) }
    }
    
    public var queryParams: [URLQueryItem] {
        get {
            var queryItems = [URLQueryItem]()
            if let routing = self.routing {
                queryItems.append(URLQueryItem(name: QueryParams.routing.rawValue, value: routing))
            }
            if let version = self.version, let versionType = self.versionType {
                queryItems.append(URLQueryItem(name: QueryParams.version, value: version))
                queryItems.append(URLQueryItem(name: QueryParams.versionType, value: versionType.rawValue))
            }
            if let refresh = self.refresh {
                queryItems.append(URLQueryItem(name: QueryParams.refresh, value: refresh.rawValue))
            }
            if let parentId = self.parent {
                queryItems.append(URLQueryItem(name: QueryParams.parent, value: parentId))
            }
            
            queryItems.append(URLQueryItem(name: QueryParams.opType, value: opType.rawValue))
            
            return queryItems
        }
    }
    
}

extension IndexRequest: Equatable {}

