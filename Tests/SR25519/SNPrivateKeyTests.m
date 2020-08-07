//
//  SNPrivateKeyTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 07.08.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

#import <XCTest/XCTest.h>
@import IrohaCrypto;

static const int KEYS_COUNT = 1;

static NSString * const SECRET_KEYS1[] = {
    @"70e1ddf7edfc4a98423a4cdfdd51e4529d228840e6e30e25f1d3502250a8055c7677a385ccf0bddfb2bafbdec086bcd2475dc46aeafad822d27e1f901eb9b278",
};

static NSString * const SECRET_KEYS2[] = {
    @"2ebcfbbe9d5f09534887e9bb3b8a5caa530411c87cdca1247e1a4a040ab5800b7677a385ccf0bddfb2bafbdec086bcd2475dc46aeafad822d27e1f901eb9b278"
};

@interface SNPrivateKeyTests : XCTestCase

@end

@implementation SNPrivateKeyTests

- (void)testInitWithNoneEd25519 {
    for (NSUInteger index = 0; index < KEYS_COUNT; index++) {
        NSError *error = nil;

        NSData *expectedEd25519Data = [[NSData alloc] initWithHexString:SECRET_KEYS1[index]
                                                                  error:&error];

        SNPrivateKey *privateKey = [[SNPrivateKey alloc] initWithFromEd25519:expectedEd25519Data
                                                                       error:&error];

        XCTAssertEqualObjects(privateKey.rawData.toHexString,
                              SECRET_KEYS2[index]);

        NSData *ed25519Data = privateKey.toEd25519Data;

        XCTAssertEqualObjects(expectedEd25519Data, ed25519Data);
    }
}

@end
