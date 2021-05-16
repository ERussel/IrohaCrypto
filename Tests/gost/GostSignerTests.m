//
//  GostSignerTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 16.05.2021.
//  Copyright © 2021 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

static const int MESSAGES_COUNT = 1;

static NSString * const PRIVATE_KEYS[] = {
    @"2d2d2d2d2d424547494e2050524956415445204b45592d2d2d2d2d0a4d44344341514177467759494b6f554442774542415145774377594a4b6f55444277454341514542424341612f5a4d623939385357657370574b427961585a320a4d2b6f6d523552636e383164767368543541697050513d3d0a2d2d2d2d2d454e442050524956415445204b45592d2d2d2d2d0a"
};

static NSString * const PUBLIC_KEYS[] = {
    @"2d2d2d2d2d424547494e205055424c4943204b45592d2d2d2d2d0a4d463477467759494b6f554442774542415145774377594a4b6f5544427745434151454241304d41424544565363664c713730394c41335056335744536a72310a47492f536244693172464a2f515430766754536e77787650486278514d37694b724a74717749726632747031792f4b4e79513564774e676c4275524d6a6e6a340a2d2d2d2d2d454e44205055424c4943204b45592d2d2d2d2d0a"
};

static NSString * const MESSAGES[] = {
    @"00000000000000000000000000000000"
};

static NSString * const SIGNATURES[] = {
    @"2bfd669dc182a84b8a48b36689d7c86accdb6174b6aa64177f73c53a1d6a69dc35e6f0ad36c0a56fb1eb0eafa968b8823d3fa8e80d17262db2f8c6a057d9f050"
};

@interface GostSignerTests : XCTestCase

@end

@implementation GostSignerTests

- (void)testSignatureVerificationFromGeneratedKeypair {
    GostKeyFactory *factory = [[GostKeyFactory alloc] init];

    NSError *error = nil;
    id<IRCryptoKeypairProtocol> keypair = [factory createRandomKeypair:&error];

    if (!keypair) {
        XCTFail(@"Nil keypair: %@", [error localizedDescription]);
        return;
    }

    NSData *data = [@"Hello world!" dataUsingEncoding:NSUTF8StringEncoding];

    GostSigner* signer = [[GostSigner alloc] initWithPrivateKey:[keypair privateKey]];

    id<IRSignatureProtocol> signature = [signer sign:data error:&error];

    if (!signature) {
        XCTFail(@"Signer failer: %@", [error localizedDescription]);
        return;
    }

    GostSignatureVerifier *verifier = [[GostSignatureVerifier alloc] init];

    BOOL verified = [verifier verify:signature forOriginalData:data usingPublicKey:[keypair publicKey]];

    XCTAssertTrue(verified);
}

- (void)testSignatureCompatability {
    GostSignatureVerifier *verifier = [[GostSignatureVerifier alloc] init];

    for (NSUInteger index = 0; index < MESSAGES_COUNT; index++) {
        NSError *error = nil;

        NSData *rawPublicKey = [[NSData alloc] initWithHexString:PUBLIC_KEYS[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        NSData *rawSignature = [[NSData alloc] initWithHexString:SIGNATURES[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        NSData *message = [[NSData alloc] initWithHexString:MESSAGES[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        GostPublicKey *publicKey = [[GostPublicKey alloc] initWithRawData:rawPublicKey error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        GostSignature *signature = [[GostSignature alloc] initWithRawData:rawSignature error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        BOOL result = [verifier verify:signature forOriginalData:message usingPublicKey:publicKey];

        XCTAssertTrue(result);
    }
}

- (void)testKeypairCompatability {
    GostSignatureVerifier *verifier = [[GostSignatureVerifier alloc] init];

    for (NSUInteger index = 0; index < MESSAGES_COUNT; index++) {
        NSError *error = nil;

        NSData *rawPrivateKey = [[NSData alloc] initWithHexString:PRIVATE_KEYS[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        NSData *rawPublicKey = [[NSData alloc] initWithHexString:PUBLIC_KEYS[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        NSData *message = [[NSData alloc] initWithHexString:MESSAGES[index] error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        GostPrivateKey *privateKey = [[GostPrivateKey alloc] initWithRawData:rawPrivateKey error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        GostPublicKey *publicKey = [[GostPublicKey alloc] initWithRawData:rawPublicKey error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        GostSigner *signer = [[GostSigner alloc] initWithPrivateKey:privateKey];

        id<IRSignatureProtocol> signature = [signer sign:message error:&error];

        if (error) {
            XCTFail(@"Did receive error: %@", [error localizedDescription]);
            return;
        }

        BOOL result = [verifier verify:signature forOriginalData:message usingPublicKey:publicKey];

        XCTAssertTrue(result);
    }
}


@end
