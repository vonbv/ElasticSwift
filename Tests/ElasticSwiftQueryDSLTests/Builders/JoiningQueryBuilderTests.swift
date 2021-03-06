//
//  JoiningQueryBuilderTests.swift
//
//
//  Created by Prafull Kumar Soni on 1/5/20.
//

import Logging
import UnitTestSettings
import XCTest

@testable import ElasticSwiftCodableUtils
@testable import ElasticSwiftCore
@testable import ElasticSwiftQueryDSL

class JoiningQueryBuilderTests: XCTestCase {
    let logger = Logger(label: "org.pksprojects.ElasticSwiftQueryDSLTests.Builders.JoiningQueryBuilderTests", factory: logFactory)

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        XCTAssert(isLoggingConfigured)
        logger.info("====================TEST=START===============================")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        logger.info("====================TEST=END===============================")
    }

    func test_01_nestedQueryBuilder() throws {
        let e = expectation(description: "execution complete")

        XCTAssertNoThrow(try NestedQueryBuilder().set(path: "path").set(query: MatchAllQuery()).build(), "Should not throw")
        e.fulfill()

        waitForExpectations(timeout: 10)
    }

    func test_02_nestedQueryBuilder_missing_path() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try NestedQueryBuilder().set(query: MatchAllQuery()).build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("path", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_03_nestedQueryBuilder_missing_query() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try NestedQueryBuilder().set(path: "path").build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("query", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_04_hasChildQueryBuilder() throws {
        let e = expectation(description: "execution complete")

        XCTAssertNoThrow(try HasChildQueryBuilder().set(type: "type").set(query: MatchAllQuery()).build(), "Should not throw")
        e.fulfill()

        waitForExpectations(timeout: 10)
    }

    func test_05_hasChildQueryBuilder_missing_type() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try HasChildQueryBuilder().set(query: MatchAllQuery()).build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("type", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_06_hasChildQueryBuilder_missing_query() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try HasChildQueryBuilder().set(type: "type").build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("query", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_07_hasParentQueryBuilder() throws {
        let e = expectation(description: "execution complete")

        XCTAssertNoThrow(try HasParentQueryBuilder().set(parentType: "parent_type").set(query: MatchAllQuery()).build(), "Should not throw")
        e.fulfill()

        waitForExpectations(timeout: 10)
    }

    func test_08_hasParentQueryBuilder_missing_parentType() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try HasParentQueryBuilder().set(query: MatchAllQuery()).build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("parentType", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_09_hasParentQueryBuilder_missing_query() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try HasParentQueryBuilder().set(parentType: "parent_type").build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("query", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_10_parentIdQueryBuilder() throws {
        let e = expectation(description: "execution complete")

        XCTAssertNoThrow(try ParentIdQueryBuilder().set(type: "type").set(id: "1").build(), "Should not throw")
        e.fulfill()

        waitForExpectations(timeout: 10)
    }

    func test_11_parentIdQueryBuilder_missing_type() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try ParentIdQueryBuilder().set(id: "1").build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("type", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }

    func test_12_parentIdQueryBuilder_missing_id() throws {
        let e = expectation(description: "execution complete")

        XCTAssertThrowsError(try ParentIdQueryBuilder().set(type: "type").build(), "missing id and doc") { error in
            logger.info("Expected Error: \(error)")
            if let error = error as? QueryBuilderError {
                switch error {
                case let .missingRequiredField(field):
                    XCTAssertEqual("id", field)
                    e.fulfill()
                default:
                    XCTFail("UnExpectedError: \(error)")
                }
            }
        }

        waitForExpectations(timeout: 10)
    }
}
