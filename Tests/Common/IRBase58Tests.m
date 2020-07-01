//
//  IBBase58Tests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 01.07.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;
#import "IRBase58TestData+Load.h"

@interface IRBase58Tests : XCTestCase

@end

@implementation IRBase58Tests

- (void)testDataToBase58 {
    NSError *error = nil;

    NSArray<IRBase58TestData*> *tests = [IRBase58TestData loadFromFilename:@"base58test.json"
                                                                     error:&error];

    if (error != nil) {
        NSString *message = [error localizedDescription];
        XCTFail("%@", message);
        return;
    }

    for (IRBase58TestData *testData in tests) {
        NSData *data = [[NSData alloc] initWithHexString:testData.hex
                                                   error:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        XCTAssertEqualObjects(testData.base58, [data toBase58]);
    }
}

- (void)testBase58ToData {
    NSError *error = nil;

    NSArray<IRBase58TestData*> *tests = [IRBase58TestData loadFromFilename:@"base58test.json"
                                                                     error:&error];

    if (error != nil) {
        NSString *message = [error localizedDescription];
        XCTFail("%@", message);
        return;
    }

    for (IRBase58TestData *testData in tests) {
        NSData *base58Data = [[NSData alloc] initWithBase58String:testData.base58];
        XCTAssertEqualObjects(testData.hex, [base58Data toHexString]);
    }
}

@end
