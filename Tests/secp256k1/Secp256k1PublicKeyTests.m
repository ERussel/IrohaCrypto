//
//  Secp256k1PublicKeyTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 12.10.2021.
//  Copyright © 2021 Ruslan Rezin. All rights reserved.
//

#import <XCTest/XCTest.h>
@import IrohaCrypto;

static const int KEYS_COUNT = 1;

static NSString * const PUBLIC_KEYS[] = {
    @"0376698beebe8ee5c74d8cc50ab84ac301ee8f10af6f28d0ffd6adf4d6d3b9b762"
};

static NSString * const UNCOMPRESSED[] = {
    @"0476698beebe8ee5c74d8cc50ab84ac301ee8f10af6f28d0ffd6adf4d6d3b9b762d46ca56d3dad2ce13213a6f42278dabbb53259f2d92681ea6a0b98197a719be3"
};

@interface Secp256k1PublicKeyTests : XCTestCase

@end

@implementation Secp256k1PublicKeyTests

- (void)testPublicKeyUncompression {
    for (NSUInteger index = 0; index < KEYS_COUNT; index++) {
        NSError *error = nil;
        NSData *compressedPublicKey = [[NSData alloc] initWithHexString:PUBLIC_KEYS[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        SECPublicKey *publicKey = [[SECPublicKey alloc] initWithRawData:compressedPublicKey error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        NSData *actualUncompressed = [publicKey uncompressed];
        NSData *expectedUncompressed = [[NSData alloc] initWithHexString:UNCOMPRESSED[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        XCTAssertEqualObjects(actualUncompressed, expectedUncompressed);
    }
}

@end
