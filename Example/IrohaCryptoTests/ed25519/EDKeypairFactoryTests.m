//
//  EDKeypairFactory.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 26.07.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;
#import "EDTestConstants.h"

@interface EDKeypairFactoryTests : XCTestCase

@end

@implementation EDKeypairFactoryTests

- (void)testRandomKeypair {
    NSError *error = nil;

    EDKeyFactory *keyFactory = [[EDKeyFactory alloc] init];
    id<IRCryptoKeypairProtocol> keypair = [keyFactory createRandomKeypair:&error];

    if (error) {
        XCTFail(@"Did receive error: %@", [error localizedDescription]);
        return;
    }

    XCTAssertNotNil(keypair);
    XCTAssertNotNil([keypair.publicKey rawData]);
    XCTAssertNotNil([keypair.publicKey rawData]);
}

- (void)testDeriviationFromSeed {
    EDKeyFactory *keyFactory = [[EDKeyFactory alloc] init];

    for (int index = 0; index < KEYS_COUNT; index++) {
        NSError *error = nil;

        NSData *seed = [[NSData alloc] initWithHexString:SEEDS[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        id<IRCryptoKeypairProtocol> keyPair = [keyFactory deriveFromSeed:seed
                                                                         error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        XCTAssertEqualObjects([keyPair.publicKey.rawData toHexString], PUBLIC_KEYS[index]);
    }
}

- (void)testDeriviationFromPrivateKey {
    EDKeyFactory *keyFactory = [[EDKeyFactory alloc] init];

    for (int index = 0; index < KEYS_COUNT; index++) {
        NSError *error = nil;

        NSData *rawPrivateKey = [[NSData alloc] initWithHexString:PRIVATE_KEYS[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        EDPrivateKey *privateKey = [[EDPrivateKey alloc] initWithRawData:rawPrivateKey
                                                                   error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        id<IRCryptoKeypairProtocol> keyPair = [keyFactory deriveFromPrivateKey:privateKey
                                                                         error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        XCTAssertEqualObjects([keyPair.publicKey.rawData toHexString], PUBLIC_KEYS[index]);
    }
}

@end
