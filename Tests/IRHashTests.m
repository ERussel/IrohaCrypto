//
//  IRSHA256Tests.m
//  IrohaCrypto_Tests
//
//  Created by Ruslan Rezin on 15/10/2018.
//  Copyright © 2018 ERussel. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

#import "Constants.h"

@interface IRHashTests : XCTestCase

@end

@implementation IRHashTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testSha3256 {
    for (int index = 0; index < HASHES_COUNT; index++) {
        NSData *originalData = [MESSAGES[index] dataUsingEncoding:NSUTF8StringEncoding];
        NSData *hashedData = [originalData sha3:IRSha3Variant256];
        NSData *expectedData = [[NSData alloc] initWithBase64EncodedString:HASH_SHA_256[index] options:0];

        XCTAssertEqualObjects(hashedData, expectedData);
    }
}

- (void)testSha3512 {
    for (int index = 0; index < HASHES_COUNT; index++) {
        NSData *originalData = [MESSAGES[index] dataUsingEncoding:NSUTF8StringEncoding];
        NSData *hashedData = [originalData sha3:IRSha3Variant512];
        NSData *expectedData = [[NSData alloc] initWithBase64EncodedString:HASH_SHA_512[index] options:0];

        XCTAssertEqualObjects(hashedData, expectedData);
    }
}

@end
