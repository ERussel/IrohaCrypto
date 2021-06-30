//
//  SS58AddressFactoryTests.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 01.07.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

static const int ADDRESS_COUNT = 6;

static NSString * const ADDRESSES[] = {
    @"EzSUv17LNHTU2xdPKLuLkPy7fCD795DZ6d5CnF4x4HSkcb4",
    @"cnUVLAjzRsrXrzEiqjxMpBwvb6YgdBy8DKibonvZgtcQY5ZKe",
    @"J6JSp4acVrUZ66tXarVMd1wtPgUQZxxe23qNoqNrpGz2xhL",
    @"E8gokmz3qYJfB2iFJuvt6HY2JHv1Jy8MjGGduR7boGi4duV",
    @"cnUVLAjzRsrXrzEiqjxMpBwvb6YgdBy8DKibonvZgtcQY5ZKe",
    @"cnUMZcGtMm89EPo2iioG6fcJLkGcvF536AgaZ4APx1wbXbhLK"
};

static NSString * const PUBLIC_KEYS[] = {
    @"6addccf0b805e2d0dc445239b800201e1fb6f17f92ef4eaa1516f4d0e2cf1664",
    @"84bdc405d139399bba3ccea5d3de23316c9deeab661f57e2f4d1720cc6649859",
    @"f40aebc0b1f17260f028faf12827e2804cf1afdf7a952191042cf74c539bd870",
    @"44ebc0867945b9ab730db393c6fd4b703404aac34bfbd896f36523aa58fe0758",
    @"84bdc405d139399bba3ccea5d3de23316c9deeab661f57e2f4d1720cc6649859",
    @"7ed10bd982f3aabeaf18d1909aa4dd4d6a49bd049d4385287a9343b3f74c4010"
};

static UInt8 const TYPES[] = {
    2,
    69,
    2,
    2,
    69,
    69
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
                                                     type:TYPES[i]
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
        NSData *accountId = [factory accountIdFromAddress:ADDRESSES[i]
                                                     type:TYPES[i]
                                                    error:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        XCTAssertEqualObjects(PUBLIC_KEYS[i], [accountId toHexString]);
        
        NSNumber* addressType = [factory typeFromAddress:ADDRESSES[i]
                                                   error:&error];

        if (error != nil) {
            NSString *message = [error localizedDescription];
            XCTFail("%@", message);
            return;
        }

        XCTAssertEqual([addressType intValue], TYPES[i]);
    }
}

- (void)testAddressFromSecp256k1 {
    // given

    NSString *expectedAddress = @"FGVmwMmpEm13aYCDtAJ5Fqxd3t5CxnWaWZMBc5Ey4E7xpMh";

    SS58AddressFactory *factory = [[SS58AddressFactory alloc] init];

    NSError *error;

    NSData *privateKeyData = [[NSData alloc] initWithHexString:@"d9706f279b7f26cfc67d04c58afeaa2da690ece1a0cc4756279755f4a05961ce" error:&error];

    if (error != nil) {
        NSString *message = [error localizedDescription];
        XCTFail("%@", message);
        return;
    }

    SECPrivateKey *privateKey = [[SECPrivateKey alloc] initWithRawData:privateKeyData
                                                                 error:&error];

    if (error != nil) {
        NSString *message = [error localizedDescription];
        XCTFail("%@", message);
        return;
    }

    // when

    SECKeyFactory *keyFactory = [[SECKeyFactory alloc] init];
    id<IRCryptoKeypairProtocol> keypair = [keyFactory deriveFromPrivateKey:privateKey error:&error];

    if (error != nil) {
        NSString *message = [error localizedDescription];
        XCTFail("%@", message);
        return;
    }

    NSString *address = [factory addressFromPublicKey:keypair.publicKey
                                                 type:2
                                                error:&error];

    if (error != nil) {
        NSString *message = [error localizedDescription];
        XCTFail("%@", message);
        return;
    }

    // then

    XCTAssertEqualObjects(address, expectedAddress);
}

@end
