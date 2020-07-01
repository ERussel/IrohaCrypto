//
//  SS58AddressFactoryTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 01.07.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

static const int ADDRESS_COUNT = 4;

static NSString * const ADDRESSES[] = {
    @"EzSUv17LNHTU2xdPKLuLkPy7fCD795DZ6d5CnF4x4HSkcb4",
    @"DV7xfT8VBuHXH8jqHvAEG3SD9T2NmaQBUiNo3UhPDXJjjCv",
    @"J6JSp4acVrUZ66tXarVMd1wtPgUQZxxe23qNoqNrpGz2xhL",
    @"E8gokmz3qYJfB2iFJuvt6HY2JHv1Jy8MjGGduR7boGi4duV"
};

static NSString * const PUBLIC_KEYS[] = {
    @"6addccf0b805e2d0dc445239b800201e1fb6f17f92ef4eaa1516f4d0e2cf1664",
    @"284519e94e8e38145b562fd3dab85909c554bd3645f5f9a37ce95d03801afe3f",
    @"f40aebc0b1f17260f028faf12827e2804cf1afdf7a952191042cf74c539bd870",
    @"44ebc0867945b9ab730db393c6fd4b703404aac34bfbd896f36523aa58fe0758"
};

@interface SS58AddressFactoryTests : XCTestCase

@end

@implementation SS58AddressFactoryTests

- (void)testSS58AddressEncoding {
    SS58AddressFactory *factory = [[SS58AddressFactory alloc] init];

    NSError *error;
    for (int i = 0; i < ADDRESS_COUNT; i++) {
        NSData *rawData = [[NSData alloc] initWithHexString:PUBLIC_KEYS[i]
                                                   error:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        SNPublicKey *publicKey = [[SNPublicKey alloc] initWithRawData:rawData
                                                                error:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        NSString *address = [factory addressFromPublicKey:publicKey
                                                     type:SNAddressTypeKusamaMain
                                                    error:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        XCTAssertEqualObjects(ADDRESSES[i], address);
    }
}

- (void)testSS58AddressDecoding {
    SS58AddressFactory *factory = [[SS58AddressFactory alloc] init];

    NSError *error;
    for (int i = 0; i < ADDRESS_COUNT; i++) {
        SNPublicKey *publicKey = [factory publicKeyFromAddress:ADDRESSES[i]
                                                          type:SNAddressTypeKusamaMain
                                                         error:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        XCTAssertEqualObjects(PUBLIC_KEYS[i], [publicKey.rawData toHexString]);
    }
}

@end
