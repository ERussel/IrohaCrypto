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
    @"3046020100301f06082a85030701010101301306072a85030202230106082a850307010102020420745a3b9d293e21b7cd11263d4cc74d1277f7449e435fb802ee3cf3f908872b9c"
};

static NSString * const PUBLIC_KEYS[] = {
    @"3066301f06082a85030701010101301306072a85030202230106082a850307010102020343000440488288d2952dcd02e9dbfbfcaaf0240a978de5ab7905a29de8c204181481ea605ea959d03869e79425a27ca25ffeccf860e3b56d3a49f4f88882d2b51b7c7426"
};

static NSString * const MESSAGES[] = {
    @"00000000000000000000000000000000"
};

static NSString * const SIGNATURES[] = {
    @"4da59ff348fe2ea4db12862b8cea1c958687b62d9921408c96c95a9329e9eb8aa582c17f998fbe54cc7671ba8f3b4d6f11974cd5cd67d1dc140309147e7d05a7"
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
