//
//  Blake2sTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 01.07.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

static const int MESSAGES_COUNT = 4;

static NSString * const MESSAGES[] = {
    @"",
    @"hello world!",
    @"привет!",
    @"69217a3079908094e11121d042354a7c1f55b6482ca1a51e1b250dfd1ed0eef96b07ae5278b0eb87df625c2cc592988ecfe4d70fa43867ccf23c0b46bf694479"
};

static NSString * const BLAKE_256[] = {
    @"69217a3079908094e11121d042354a7c1f55b6482ca1a51e1b250dfd1ed0eef9",
    @"6b07ae5278b0eb87df625c2cc592988ecfe4d70fa43867ccf23c0b46bf694479",
    @"f6d028d866efc9ad8a253292238dc19968d9025ba896a8f5ae8ec1dce58a663c",
    @"27cf83347905093044e264277f7afb4e190702f33778ad40362a51ae78db9f77"
};

@interface Blake2sTests : XCTestCase

@end

@implementation Blake2sTests

- (void)testBlake {

    NSError *error;
    for (int i = 0; i < MESSAGES_COUNT; i++) {
        NSData *message = [MESSAGES[i] dataUsingEncoding:NSUTF8StringEncoding];
        NSData *hashedMessage = [message blake2sWithError:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        XCTAssertEqualObjects(BLAKE_256[i], [hashedMessage toHexString]);
    }
}

@end
