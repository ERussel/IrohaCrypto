//
//  GostSignerTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 16.05.2021.
//  Copyright © 2021 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

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

@end
