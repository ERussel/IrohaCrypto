//
//  IRHexTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 23/10/2018.
//  Copyright © 2018 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;
#import "Constants.h"

@interface IRHexTests : XCTestCase

@end

@implementation IRHexTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDataToHex {
    for (int index; index < MESSAGES_COUNT; index++) {
        NSString *hexString = [[[NSData alloc] initWithBase64EncodedString:MESSAGES[index] options:0] toHexString];
        XCTAssertEqualObjects(hexString, HEX_MESSAGES[index]);
    }
}

- (void)testHexToData {
    for (int index; index < MESSAGES_COUNT; index++) {
        NSData *data = [[NSData alloc] initWithHexString:HEX_MESSAGES[index]];
        NSData *expected = [[NSData alloc] initWithBase64EncodedString:MESSAGES[index] options:0];
        XCTAssertEqualObjects(data, expected);
    }
}

@end
