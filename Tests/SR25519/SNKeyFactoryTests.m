//
//  SNKeyFactoryTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 26.06.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;
#import "SNAccountTestData+Load.h"

@interface SNKeyFactoryTests : XCTestCase

@property(nonatomic, strong)SNKeyFactory *keysFactory;

@end

@implementation SNKeyFactoryTests

- (void)setUp {
    [super setUp];

    _keysFactory = [[SNKeyFactory alloc] init];
}

- (void)tearDown {
    _keysFactory = nil;

    [super tearDown];
}

- (void)testKeypairDeriviationFromSeed {
    NSError *error = nil;

    NSArray<SNAccountTestData*> *tests = [SNAccountTestData loadFromFilename:@"kusamaPubkeyTestVectors.json"
                                                                    language:@"english"
                                                                       error:&error];

    if (error != nil) {
        NSString *message = [error localizedDescription];
        XCTFail("%@", message);
        return;
    }

    SNBIP39SeedCreator *seedCreator = [[SNBIP39SeedCreator alloc] init];
    IRMnemonicCreator *mnemonicCreator = [[IRMnemonicCreator alloc] initWithLanguage:IREnglish];
    SNKeyFactory *keypairFactory = [[SNKeyFactory alloc] init];

    for (SNAccountTestData *testData in tests) {
        NSError *error = nil;

        id<IRMnemonicProtocol> mnemonic = [mnemonicCreator mnemonicFromList:testData.mnemonic
                                                                      error:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        NSData *fullSeed = [seedCreator deriveSeedFrom:mnemonic.entropy
                                        passphrase:@""
                                             error:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        NSData *seed = [fullSeed subdataWithRange:NSMakeRange(0, 32)];

        XCTAssertEqualObjects([seed toHexString], testData.seed);

        SNKeypair *keypair = [keypairFactory createKeypairFromSeed:seed
                                                             error:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        XCTAssertEqualObjects([keypair.publicKey.rawData toHexString], testData.publicKey);
    }
}

@end
