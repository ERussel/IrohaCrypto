//
//  IrohaCryptoTests.m
//  IrohaCryptoTests
//
//  Created by ERussel on 10/07/2018.
//  Copyright (c) 2018 ERussel. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

#import "Constants.h"

@interface IRIrohaKeyFactoryTests : XCTestCase

@property(nonatomic, strong)IRIrohaKeyFactory *keysFactory;

@end

@implementation IRIrohaKeyFactoryTests

- (void)setUp {
    [super setUp];

    _keysFactory = [[IRIrohaKeyFactory alloc] init];
}

- (void)tearDown {
    _keysFactory = nil;

    [super tearDown];
}

- (void)testRandomKeypair {
    id<IRCryptoKeypairProtocol> keypair = [_keysFactory createRandomKeypair];

    XCTAssertNotNil(keypair);
    XCTAssertNotNil([keypair.publicKey rawData]);
    XCTAssertNotNil([keypair.publicKey rawData]);
}

- (void)testKeyDeriviation {
    for (int index = 0; index < KEYS_COUNT; index++) {
        NSData *rawKey = [[NSData alloc] initWithBase64EncodedString:PRIVATE_KEYS[index] options:0];
        IRIrohaPrivateKey *privateKey = [[IRIrohaPrivateKey alloc] initWithRawData:rawKey];
        id<IRCryptoKeypairProtocol> keyPair = [_keysFactory deriveFromPrivateKey:privateKey];

        XCTAssertEqualObjects(keyPair.privateKey.rawData, privateKey.rawData);
        XCTAssertEqualObjects([keyPair.publicKey.rawData base64EncodedStringWithOptions:0], PUBLIC_KEYS[index]);
    }
}

@end

