//
//  IRSignatureTests.m
//  IrohaCrypto_Tests
//
//  Created by Ruslan Rezin on 15/10/2018.
//  Copyright © 2018 ERussel. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

#import "Constants.h"

@interface IRSignatureTests : XCTestCase

@end

@implementation IRSignatureTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPredefinedSignatures {
    for (int index = 0; index < MESSAGES_COUNT; index++) {
        NSData *rawKey = [[NSData alloc] initWithBase64EncodedString:PRIVATE_KEYS[index] options:0];
        IREd25519PrivateKey *privateKey = [[IREd25519PrivateKey alloc] initWithRawData:rawKey];

        IREd25519Sha512Signer *signer = [[IREd25519Sha512Signer alloc] initWithPrivateKey:privateKey];

        NSData *message = [[NSData alloc] initWithBase64EncodedString:MESSAGES[index] options:0];
        id<IRSignatureProtocol> signature = [signer sign:message];

        NSData *expectedSignatureData = [[NSData alloc] initWithBase64EncodedString:SIGNATURES[index] options:0];

        XCTAssertEqualObjects(signature.rawData, expectedSignatureData);
    }
}

- (void)testSignVerify {
    IREd25519Sha512Verifier *verifier = [[IREd25519Sha512Verifier alloc] init];

    for (int index = 0; index < MESSAGES_COUNT; index++) {
        NSData *rawPrivateKey = [[NSData alloc] initWithBase64EncodedString:PRIVATE_KEYS[index] options:0];
        IREd25519PrivateKey *privateKey = [[IREd25519PrivateKey alloc] initWithRawData:rawPrivateKey];

        NSData *rawPublicKey = [[NSData alloc] initWithBase64EncodedString:PUBLIC_KEYS[index] options:0];
        IREd25519PublicKey *publicKey = [[IREd25519PublicKey alloc] initWithRawData:rawPublicKey];

        IREd25519Sha512Signer *signer = [[IREd25519Sha512Signer alloc] initWithPrivateKey:privateKey];

        NSData *message = [[NSData alloc] initWithBase64EncodedString:MESSAGES[index] options:0];
        id<IRSignatureProtocol> signature = [signer sign:message];

        XCTAssertTrue([verifier verify:signature forOriginalData:message usingPublicKey:publicKey]);
    }
}

@end
