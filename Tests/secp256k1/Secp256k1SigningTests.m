//
//  Secp256k1SigningTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 25.07.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

static const int MESSAGES_COUNT = 1;

static NSString * const MESSAGES[] = {
    @"secp256k1"
};

static NSString * const SIGNATURES[] = {
    @"92fcacf0946bbd10b31dfe16d567ed1d3014e81007dd9e5256e19c0f07eacc1643b151ca29e449a765e16a7ce59b88d800467d6b3412d30ea8ad22307a59664b00"
};

static NSString * const ACCOUNTS[] = {
    @"59f587c045d4d4e9aa1016eae43770fc0551df8a385027723342753a876aeef0"
};

@interface Secp256k1SigningTests : XCTestCase

@end

@implementation Secp256k1SigningTests

- (void)testSignAndVerify {

    SECKeyFactory *factory = [[SECKeyFactory alloc] init];

    NSError *error = nil;
    id<IRCryptoKeypairProtocol> keypair = [factory createRandomKeypair: &error];

    SECSigner *signer = [[SECSigner alloc] initWithPrivateKey:keypair.privateKey];
    SECSignatureVerifier *verifier = [[SECSignatureVerifier alloc] init];

    for (NSUInteger index = 0; index < MESSAGES_COUNT; index++) {
        NSData *hash = [[MESSAGES[index] dataUsingEncoding:NSUTF8StringEncoding] blake2b:32 error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        id<IRSignatureProtocol> signature = [signer sign:hash error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        BOOL result = [verifier verify:signature forOriginalData:hash usingPublicKey:keypair.publicKey];

        XCTAssertTrue(result);
    }
}

- (void)testPublicKeyDeriviation {
    NSError *error = nil;
    SECSignatureVerifier *verifier = [[SECSignatureVerifier alloc] init];

    for (NSUInteger index = 0; index < MESSAGES_COUNT; index++) {
        NSData *hash = [[MESSAGES[index] dataUsingEncoding:NSUTF8StringEncoding] blake2b:32 error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        NSData *rawSignature = [[NSData alloc] initWithHexString:SIGNATURES[index]
                                                           error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        SECSignature *signature = [[SECSignature alloc] initWithRawData:rawSignature
                                                                  error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        id<IRPublicKeyProtocol> result = [verifier recoverFromSignature:signature
                                                        forOriginalData:hash
                                                                  error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        NSData *expectedAccount = [[NSData alloc] initWithHexString:ACCOUNTS[index]
                                                              error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        NSData *derivedAccount = [result.rawData blake2b:32 error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        XCTAssertEqualObjects(expectedAccount, derivedAccount);
    }
}

@end
