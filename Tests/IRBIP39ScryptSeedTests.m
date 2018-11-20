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
    @"8986c5b27dfb70f58592fe53d76a765b8d75789cd28e0e630b2cfba9d1c2522a",
    @"49ec553ea961eff6e7e7c2df51e11c45eeee0363d4509c200cde98d37165108d",
    @"3c15118ea2b9210a9a3d690397455eacb7a3d20520f42c4416db263df2c19b0f",
    @"63850903c3d3dbf60369fd8a63cae9a04e4afec9778eb00dfeb123233355899b"
};

@interface IRBIP39ScryptSeedTests : XCTestCase

@end

@implementation IRBIP39ScryptSeedTests

- (void)testSeedMatching {
    IRBIP39ScryptSeedCreator *seedCreator = [IRBIP39ScryptSeedCreator defaultCreator];
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
    IRBIP39ScryptSeedCreator *seedCreator = [IRBIP39ScryptSeedCreator defaultCreator];

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
    IRBIP39ScryptSeedCreator *seedCreator = [IRBIP39ScryptSeedCreator defaultCreator];

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
    IRBIP39ScryptSeedCreator *seedCreator = [IRBIP39ScryptSeedCreator defaultCreator];

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
