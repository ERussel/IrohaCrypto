//
//  secp256k1Tests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 24.07.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

static const int KEYS_COUNT = 4;

static NSString * const PRIVATE_KEYS[] = {
    @"f2360e871c830d397fe221382b503f07ddd8763df81a94bb2504390a2fb91f59",
    @"5385355a5118ec732b9dbcf1668ba21db38b07cf79082dafa9a7cc4b52e4abb0",
    @"83ec65cf9a8a7442d808aef6f8987599f1ba3be880769bb3a20621b13adbd476",
    @"0fd50580eb5a58b0eee60c77656dffa50094b539262366f1227d3babfd7343e5"
};

static NSString * const PUBLIC_KEYS[] = {
    @"036b0aa6beab469dd2b748a0ff5ddbe3d13df1e15c9d28a2aa057212994e127bea",
    @"03929e4f93cdad265751ad8f6365185d8e937610d19b510400f5867d542d60a313",
    @"0388299e4cfaa33d180a026bd54a46ad98df129a131320a9d2fd6f80e64bc3db39",
    @"036edc954685ad89f0a23b0fb1eb2b9c3a8600eee9091c758426dfb2bc7889a7c3"
};

@interface Secp256k1KeypairTests : XCTestCase

@end

@implementation Secp256k1KeypairTests

- (void)testKeypairDeriviation {
    SECKeyFactory *factory = [[SECKeyFactory alloc] init];

    for (NSUInteger index = 0; index < KEYS_COUNT; index++) {
        NSError *error = nil;
        NSData *rawPrivateKey = [[NSData alloc] initWithHexString:PRIVATE_KEYS[index]
                                                            error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        SECPrivateKey *privateKey = [[SECPrivateKey alloc] initWithRawData:rawPrivateKey
                                                                     error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        id<IRCryptoKeypairProtocol> keypair = [factory deriveFromPrivateKey:privateKey
                                                                      error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        NSData *rawPublicKey = [[NSData alloc] initWithHexString:PUBLIC_KEYS[index]
                                                                error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        XCTAssertEqualObjects(rawPublicKey, keypair.publicKey.rawData);
    }
}

- (void)testRandomKeypair {
    // given

    SECKeyFactory *keyFactory = [[SECKeyFactory alloc] init];
    NSError *error;

    // when

    id<IRCryptoKeypairProtocol> expectedKeypair = [keyFactory createRandomKeypair:&error];

    if (error) {
        XCTFail(@"Did receive error: %@", [error localizedDescription]);
        return;
    }

    id<IRCryptoKeypairProtocol> derivedKeypair = [keyFactory deriveFromPrivateKey:expectedKeypair.privateKey
                                                                            error:&error];

    if (error) {
        XCTFail(@"Did receive error: %@", [error localizedDescription]);
        return;
    }

    // then

    XCTAssertEqualObjects(expectedKeypair.publicKey.rawData, derivedKeypair.publicKey.rawData);
}

@end
