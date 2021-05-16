//
//  GostKeypairFactoryTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 13.05.2021.
//  Copyright © 2021 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

@interface GostKeypairFactoryTests : XCTestCase

@end

@implementation GostKeypairFactoryTests

- (void)testGenerateKeypair {
    GostKeyFactory *factory = [[GostKeyFactory alloc] init];

    NSError *error = nil;
    id<IRCryptoKeypairProtocol> keypair = [factory createRandomKeypair:&error];

    if (!keypair) {
        XCTFail(@"Nil keypair: %@", [error localizedDescription]);
        return;
    }

    // check that private key can be encoded and decoded

    NSData *expectedRawPrivateKey = [[keypair privateKey] rawData];

    GostPrivateKey *privateKey = [[GostPrivateKey alloc] initWithRawData:expectedRawPrivateKey
                                                                  error:&error];

    XCTAssertEqualObjects(expectedRawPrivateKey, [privateKey rawData]);

    // check that public key can be encoded and decoded

    NSData *expectedRawPublicKey = [[keypair publicKey] rawData];
    GostPublicKey *publicKey = [[GostPublicKey alloc] initWithRawData:expectedRawPublicKey error:&error];

    XCTAssertEqualObjects(expectedRawPublicKey, [publicKey rawData]);
}

@end
