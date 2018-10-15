//
//  IrohaCryptoTests.m
//  IrohaCryptoTests
//
//  Created by ERussel on 10/07/2018.
//  Copyright (c) 2018 ERussel. All rights reserved.
//

@import XCTest;
@import IrohaCrypto;

@interface IRCryptoKeyFactoryTests : XCTestCase

@property(nonatomic, strong)IREd25519KeyFactory *keysFactory;

@end

@implementation IRCryptoKeyFactoryTests

- (void)setUp {
    [super setUp];

    _keysFactory = [[IREd25519KeyFactory alloc] init];
}

- (void)tearDown {
    _keysFactory = nil;

    [super tearDown];
}

- (void)testRandomKeypair {
    id<IRCryptoKeypairProtocol> keypair = [_keysFactory createRandomKeypair];

    XCTAssertNotNil(keypair);
    XCTAssertNotNil([keypair.publicKey rawData]);
    XCTAssertNotNil([keypair.publicKey rawData]);
}

- (void)testKeyDeriviation {
    NSArray<NSString *> *privateKeys = @[@"nWGxne/9WmC6hEr0kuwsxERJxWl7MmkZcDusAxyuf2A=",
                                         @"TM0Imyj/ltqdtsNG7BFOD1uKMZ81q6Yk2oz27U+4pvs=",
                                         @"xaqN9D+fg3vtt0QvMdy3sWbThTUHbwlLhc46LgtEWPc=",
                                         @"DUoFsHNSpUNuGANW2grm76A0X/f7FXJXV3LoAF7ZeOk="];

    NSArray<NSString *> *publicKeys = @[@"p9QfLqYBZtLE/L4UXpfkuO+PAkcekrsxWMcFndfQ+ZA=",
                                        @"GUODZzUvZ4tBh65p/mjchh0VSawNJpNAtNUjh0Mrid0=",
                                        @"oI/UbuU05i0I5XeoSihgGQPUJL3yiL5FZE7OKTZylD4=",
                                        @"0dD5gL0zt1zn26r9taanQ5od4JpYBk7sD7c3bc88XSM="];

    for (int index = 0; index < privateKeys.count; index++) {
        NSData *rawKey = [[NSData alloc] initWithBase64EncodedString:privateKeys[index] options:0];
        IREd25519PrivateKey *privateKey = [[IREd25519PrivateKey alloc] initWithRawData:rawKey];
        id<IRCryptoKeypairProtocol> keyPair = [_keysFactory deriveFromPrivateKey:privateKey];

        XCTAssertEqualObjects(keyPair.privateKey.rawData, privateKey.rawData);
        XCTAssertEqualObjects([keyPair.publicKey.rawData base64EncodedStringWithOptions:0], publicKeys[index]);
    }
}

@end

