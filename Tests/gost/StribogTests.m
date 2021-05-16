//
//  StribogTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 10.05.2021.
//  Copyright © 2021 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

static const int MESSAGES_COUNT = 2;

static NSString * const MESSAGES[] = {
    @"",
    @"012345678901234567890123456789012345678901234567890123456789012"
};

static NSString * const HASHES[] = {
    @"3f539a213e97c802cc229d474c6aa32a825a360b2a933a949fd925208d9ce1bb",
    @"9d151eefd8590b89daa6ba6cb74af9275dd051026bb149a452fd84e5e57b5500"
};

@interface StribogTests : XCTestCase

@end

@implementation StribogTests

- (void)testHashCorrect {

    NSError *error;
    for (int i = 0; i < MESSAGES_COUNT; i++) {
        NSData *message = [MESSAGES[i] dataUsingEncoding:NSUTF8StringEncoding];
        NSData *hashedMessage = [message stribogWithError:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        XCTAssertEqualObjects(HASHES[i], [hashedMessage toHexString]);
    }
}

@end
