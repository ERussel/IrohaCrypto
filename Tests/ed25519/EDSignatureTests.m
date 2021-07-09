//
//  EDSignatureTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 26.07.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;
#import "EDTestConstants.h"

@interface EDSignatureTests : XCTestCase

@end

@implementation EDSignatureTests

- (void)testVerifyPredefinedSignatures {
    EDSignatureVerifier *verifier = [[EDSignatureVerifier alloc] init];

    for (int index = 0; index < MESSAGES_COUNT; index++) {
        NSError *error = nil;

        NSData *rawPublicKey = [[NSData alloc] initWithHexString:PUBLIC_KEYS[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        EDPublicKey *publicKey = [[EDPublicKey alloc] initWithRawData:rawPublicKey error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        NSData *message = [MESSAGES[index] dataUsingEncoding:NSUTF8StringEncoding];

        NSData *rawSignature = [[NSData alloc] initWithHexString:SIGNATURES[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        EDSignature *signature = [[EDSignature alloc] initWithRawData:rawSignature error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        NSLog(@"Signature: %@", signature.rawData.toHexString);

        XCTAssertTrue([verifier verify:signature forOriginalData:message usingPublicKey:publicKey]);
    }
}

- (void)testSignAndVerify {
    EDSignatureVerifier *verifier = [[EDSignatureVerifier alloc] init];
    EDKeyFactory *factory = [[EDKeyFactory alloc] init];

    for (int index = 0; index < MESSAGES_COUNT; index++) {
        NSError *error = nil;

        NSData *rawSeed = [[NSData alloc] initWithHexString:SEEDS[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        id<IRCryptoKeypairProtocol> keypair = [factory deriveFromSeed:rawSeed
                                                                error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        NSData *message = [MESSAGES[index] dataUsingEncoding:NSUTF8StringEncoding];

        EDSigner *signer = [[EDSigner alloc] initWithPrivateKey:keypair.privateKey];

        id<IRSignatureProtocol> signature = [signer sign:message error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        XCTAssertTrue([verifier verify:signature forOriginalData:message
                        usingPublicKey:keypair.publicKey]);
    }
}

@end
