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

@interface IRIrohaSignatureTests : XCTestCase

@end

@implementation IRIrohaSignatureTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testPredefinedSignatures {
    for (int index = 0; index < MESSAGES_COUNT; index++) {
        NSData *rawKey = [[NSData alloc] initWithBase64EncodedString:PRIVATE_KEYS[index] options:0];
        IRIrohaPrivateKey *privateKey = [[IRIrohaPrivateKey alloc] initWithRawData:rawKey error:nil];

        IRIrohaSigner *signer = [[IRIrohaSigner alloc] initWithPrivateKey:privateKey];

        NSData *message = [[NSData alloc] initWithBase64EncodedString:MESSAGES[index] options:0];
        id<IRSignatureProtocol> signature = [signer sign:message error:nil];

        NSData *expectedSignatureData = [[NSData alloc] initWithBase64EncodedString:SIGNATURES[index] options:0];

        XCTAssertEqualObjects(signature.rawData, expectedSignatureData);
    }
}

- (void)testSignVerify {
    IRIrohaSignatureVerifier *verifier = [[IRIrohaSignatureVerifier alloc] init];

    for (int index = 0; index < MESSAGES_COUNT; index++) {
        NSData *rawPrivateKey = [[NSData alloc] initWithBase64EncodedString:PRIVATE_KEYS[index] options:0];
        IRIrohaPrivateKey *privateKey = [[IRIrohaPrivateKey alloc] initWithRawData:rawPrivateKey
                                                                             error:nil];

        NSData *rawPublicKey = [[NSData alloc] initWithBase64EncodedString:PUBLIC_KEYS[index] options:0];
        IRIrohaPublicKey *publicKey = [[IRIrohaPublicKey alloc] initWithRawData:rawPublicKey
                                                                          error:nil];

        IRIrohaSigner *signer = [[IRIrohaSigner alloc] initWithPrivateKey:privateKey];

        NSData *message = [[NSData alloc] initWithBase64EncodedString:MESSAGES[index] options:0];
        id<IRSignatureProtocol> signature = [signer sign:message error:nil];

        XCTAssertTrue([verifier verify:signature forOriginalData:message usingPublicKey:publicKey]);
    }
}

@end
