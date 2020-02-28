//
//  IRBIP39ScryptSeedTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 17/11/2018.
//  Copyright © 2018 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;
#import "Constants.h"

static NSString* const TEST_PASSWORD = @"testPassword";
static NSString* const TEST_PROJECT = @"testProject";
static NSString* const TEST_PURPOSE = @"test purpose";
static const NSUInteger DEFAULT_SEED_LENGTH = 32;

static const NSUInteger SCRYPT_TEST_COUNT = 4;

static NSString* const SCRYPT_MNEMONICS[] = {
    @"ice just spike final seminar crater shadow ensure fame rival flip put virtual picnic galaxy",
    @"essence long fade naive almost board east unknown equip option oil version stone couple arch",
    @"couple raw spatial shop person process still manage hidden carpet expect moment mammal bright pumpkin",
    @"jaguar record fetch under cruise permit canoe main jazz clock furnace mind blast chunk odor"
};

static NSString* const SCRYPT_SEED[] = {
    @"2a58dee913307de72e6cf7ea851ab094a48be772f7177b846df19098825d1d11",
    @"a56b245dee3da0be3d566d1b80194e5547a330a986b2834e2019412a110b3638",
    @"fa2672dec1273487e71dcce4e14124e1004ffd9eda0e2650c8165024a7d20c6e",
    @"62e74dda4085b3c9c0e0de6e39aa925842b99a71447c3fbdcc0d4f5f5f36428b"
};

@interface IRScryptSeedTests : XCTestCase

@end

@implementation IRScryptSeedTests

- (void)testSeedMatching {
    IRSeedCreator *seedCreator = [IRSeedCreator scrypt];
    for (NSUInteger index = 0; index < SCRYPT_TEST_COUNT; index++) {
        NSError *error = nil;
        NSData *seed = [seedCreator deriveSeedFromMnemonicPhrase:SCRYPT_MNEMONICS[index]
                                                        password:TEST_PASSWORD
                                                         project:TEST_PROJECT
                                                         purpose:TEST_PURPOSE
                                                          length:DEFAULT_SEED_LENGTH
                                                           error:&error];
        XCTAssertNil(error);

        NSData *expectedSeed = [[NSData alloc] initWithHexString:SCRYPT_SEED[index]];

        XCTAssertEqualObjects(seed, expectedSeed);
    }
}

- (void)testMnemonicMatchesSeedFromInfo {
    IRSeedCreator *seedCreator = [IRSeedCreator scrypt];

    for(IRMnemonicStrength strength = IREntropy128; strength <= IREntropy320; strength += IREntropy160 - IREntropy128) {
        id<IRMnemonicProtocol> mnemonic = nil;
        NSError *error = nil;
        NSData *seed = [seedCreator randomSeedWithMnemonicStrength:strength
                                                          password:TEST_PASSWORD
                                                           project:TEST_PROJECT
                                                           purpose:TEST_PURPOSE
                                                            length:DEFAULT_SEED_LENGTH
                                                    resultMnemonic:&mnemonic
                                                             error:&error];
        XCTAssertNotNil(seed);
        XCTAssertNotNil(mnemonic);
        XCTAssertNil(error);

        NSData *restoredSeed = [seedCreator deriveSeedFromMnemonicPhrase:[mnemonic toString]
                                                                password:TEST_PASSWORD
                                                                 project:TEST_PROJECT
                                                                 purpose:TEST_PURPOSE
                                                                  length:DEFAULT_SEED_LENGTH
                                                                   error:&error];

        XCTAssertEqualObjects(restoredSeed, seed);
    }
}

- (void)testMnemonicMatchesSeedFromSalt {
    IRSeedCreator *seedCreator = [IRSeedCreator scrypt];

    for (NSUInteger hashIndex = 0; hashIndex < HASHES_COUNT; hashIndex++) {
        NSData *salt = [[NSData alloc] initWithHexString:HASH_SHA_256[hashIndex]];

        for(IRMnemonicStrength strength = IREntropy128; strength <= IREntropy320; strength += IREntropy160 - IREntropy128) {
            id<IRMnemonicProtocol> mnemonic = nil;
            NSError *error = nil;
            NSData *seed = [seedCreator randomSeedWithMnemonicStrength:strength
                                                                  salt:salt
                                                                length:DEFAULT_SEED_LENGTH
                                                        resultMnemonic:&mnemonic
                                                                 error:&error];
            XCTAssertNotNil(seed);
            XCTAssertNotNil(mnemonic);
            XCTAssertNil(error);

            NSData *restoredSeed = [seedCreator deriveSeedFromMnemonicPhrase:[mnemonic toString]
                                                                        salt:salt
                                                                      length:DEFAULT_SEED_LENGTH
                                                                       error:&error];
            XCTAssertEqualObjects(restoredSeed, seed);
        }
    }
}

- (void)testRandomSeedPerformanceExample {
    IRSeedCreator *seedCreator = [IRSeedCreator scrypt];

    [self measureBlock:^{
        for(IRMnemonicStrength strength = IREntropy128; strength <= IREntropy320; strength += IREntropy160 - IREntropy128) {
            id<IRMnemonicProtocol> mnemonic = nil;
            NSError *error = nil;
            NSData *seed = [seedCreator randomSeedWithMnemonicStrength:strength
                                                              password:TEST_PASSWORD
                                                               project:TEST_PROJECT
                                                               purpose:TEST_PURPOSE
                                                                length:DEFAULT_SEED_LENGTH
                                                        resultMnemonic:&mnemonic
                                                                 error:&error];
            XCTAssertNotNil(seed);
            XCTAssertNotNil(mnemonic);
            XCTAssertNil(error);
        }
    }];
}

@end
