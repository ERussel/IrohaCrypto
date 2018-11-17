//
//  IRMnemonicCreatorTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 15/11/2018.
//  Copyright © 2018 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;
#import "Constants.h"

@interface IRMnemonicCreatorTests : XCTestCase

@end

@implementation IRMnemonicCreatorTests

- (void)testMnemonicCreationPerformance {
    IRBIP39MnemonicCreator *mnemonicCreator = [[IRBIP39MnemonicCreator alloc] initWithLanguage:IREnglish];

    [self measureBlock:^{
        for(IRMnemonicStrength strength = IREntropy128; strength <= IREntropy320; strength += 32) {
            id<IRMnemonicProtocol> mnemonic = [mnemonicCreator randomMnemonic:strength error:nil];
            XCTAssertNotNil(mnemonic);
        }
    }];
}

- (void)testMnemonicValidness {
    IRBIP39MnemonicCreator *mnemonicCreator = [[IRBIP39MnemonicCreator alloc] initWithLanguage:IREnglish];

    for(IRMnemonicStrength strength = IREntropy128; strength <= IREntropy320; strength += 32) {
        NSData *entropy = [self randomData:strength / 8];

        id<IRMnemonicProtocol> mnemonic = [mnemonicCreator mnemonicFromEntropy:entropy error:nil];
        XCTAssertNotNil(mnemonic);

        id<IRMnemonicProtocol> restoredMnemonic = [mnemonicCreator mnemonicFromList:mnemonic.allWords error:nil];
        XCTAssertNotNil(restoredMnemonic);

        XCTAssertEqualObjects(entropy, restoredMnemonic.entropy);
    }
}

- (void)testEntropyToMnemonic {
    IRBIP39MnemonicCreator *mnemonicCreator = [[IRBIP39MnemonicCreator alloc] initWithLanguage:IREnglish];

    for(int index = 0; index < MNEMONIC_COUNT; index++) {
        NSData *entropy = [[NSData alloc] initWithHexString:MNEMONIC_ENTROPY[index]];

        id<IRMnemonicProtocol> mnemonic = [mnemonicCreator mnemonicFromEntropy:entropy error:nil];
        XCTAssertNotNil(mnemonic);

        NSString *mnemonicString = [mnemonic toString];
        NSString *expectedString = MNEMONIC_STRING[index];
        XCTAssertEqualObjects(mnemonicString, expectedString);
    }
}

- (void)testMnemonicToEntropy {
    IRBIP39MnemonicCreator *mnemonicCreator = [[IRBIP39MnemonicCreator alloc] initWithLanguage:IREnglish];

    for(int index = 0; index < MNEMONIC_COUNT; index++) {
        NSArray<NSString*>* words = [MNEMONIC_STRING[index] componentsSeparatedByString:@" "];

        id<IRMnemonicProtocol> mnemonic = [mnemonicCreator mnemonicFromList:words error:nil];
        XCTAssertNotNil(mnemonic);

        NSData *expectedEntropy = [[NSData alloc] initWithHexString:MNEMONIC_ENTROPY[index]];
        NSData *resultEntropy = mnemonic.entropy;
        XCTAssertEqualObjects(expectedEntropy, resultEntropy);
    }
}

- (void)testInvalidChecksum {
    IRBIP39MnemonicCreator *mnemonicCreator = [[IRBIP39MnemonicCreator alloc] initWithLanguage:IREnglish];

    NSError *error;
    id<IRMnemonicProtocol> mnemonic = [mnemonicCreator mnemonicFromList:[INVALID_CHECKSUM_MNEMONIC componentsSeparatedByString:@" "]
                                                                  error:&error];
    XCTAssertNil(mnemonic);
    XCTAssertEqual([error code], IRChecksumFailed);
}

- (void)testInvalidEntropyLength {
    IRBIP39MnemonicCreator *mnemonicCreator = [[IRBIP39MnemonicCreator alloc] initWithLanguage:IREnglish];

    for(NSUInteger strength = IREntropy128 + 1; strength < IREntropy160; strength++) {
        NSData *entropy = [self randomData:strength];

        NSError *error;
        id<IRMnemonicProtocol> mnemonic = [mnemonicCreator mnemonicFromEntropy:entropy
                                                                      error:&error];
        XCTAssertNil(mnemonic);
        XCTAssertEqual([error code], IRInvalidEntropyLength);
    }
}

#pragma mark - Private

- (NSData*)randomData:(NSUInteger)length {
    NSMutableData *seed = [NSMutableData dataWithLength:length];

    int status = SecRandomCopyBytes(kSecRandomDefault, seed.length, seed.mutableBytes);

    if (status != errSecSuccess) {
        return nil;
    }

    return seed;
}

@end
