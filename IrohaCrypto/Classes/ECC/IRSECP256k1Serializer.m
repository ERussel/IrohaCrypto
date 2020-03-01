//
//  IRSECP256k1CompressedSerializer.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 29.02.2020.
//

#import "IRSECP256k1Serializer.h"
#import <ECC256k1/secp256k1.h>
#import "IRSECP256k1Constants.h"
#import "IRSECP256k1PublicKey.h"

@interface IRSECP256k1Serializer()

@end

@implementation IRSECP256k1Serializer

#pragma mark - Init

- (nonnull instancetype)initWithCompressed:(BOOL)compressed {
    if (self = [super init]) {
        _compressed = compressed;
    }

    return self;
}

#pragma mark - IRCryptoKeySerializer

- (nullable NSData*)serialize:(id<IRCryptoKeyProtocol>)key error:(NSError*_Nullable*_Nullable)error {

    NSUInteger length = _compressed ? 33 : 65;
    NSMutableData *output = [NSMutableData dataWithLength:length];
    unsigned int flags = _compressed ? SECP256K1_EC_COMPRESSED : SECP256K1_EC_UNCOMPRESSED;

    secp256k1_pubkey publicKeyRaw;
    memcpy(publicKeyRaw.data, key.rawData.bytes, [IRSECP256k1PublicKey length]);

    int result = secp256k1_ec_pubkey_serialize(NULL, output.mutableBytes, &length, &publicKeyRaw, flags);

    if (result != SECP256k1_SUCCESS) {
        return nil;
    }

    return  output;
}

@end
