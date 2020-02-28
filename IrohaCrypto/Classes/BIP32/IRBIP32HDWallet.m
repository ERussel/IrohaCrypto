//
//  IRHDWallet.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 27.02.2020.
//

#import "IRBIP32HDWallet.h"
#import <CommonCrypto/CommonCrypto.h>
#import "IRCryptoKeyFactory.h"
#import "IRNumberSerializer.h"
@import Accelerate;

static NSString* const INITIAL_KEY = @"Bitcoin seed";
const uint32_t HARDENED_THRESHOLD = 1 << 31;
const int INT_SERIALIZATION_LENGTH = 4;

@interface IRBIP32HDWallet()

@property(strong, nonatomic)id<IRCryptoKeyFactoryProtocol> keyFactory;
@property(strong, nonatomic)id<IRNumberSerializerProtocol> numberSerializer;
@property(strong, nonatomic)NSData * _Nonnull chainCode;
@property(strong, nonatomic)id<IRCryptoKeypairProtocol> _Nonnull keypair;

@end

@implementation IRBIP32HDWallet

#pragma mark - Initialize

- (nullable instancetype)initWithSeed:(nonnull NSData*)seed error:(NSError*_Nullable*_Nullable)error {
    if (self = [super init]) {
        _numberSerializer = [[IRBigIndianSerializer alloc] init];

        [self initializeMasterExtendedKey:seed error:error];

        if (!_chainCode || !_keypair) {
            return nil;
        }
    }

    return self;
}

#pragma mark - Public

- (nullable instancetype)hardenedWithIndex:(uint32_t)index error:(NSError*_Nullable*_Nullable)error; {
    if (![[self class] validateIndex:index error:error]) {
        return nil;
    }

    NSMutableData *data = [NSMutableData dataWithLength:1];
    [data appendData:_keypair.privateKey.rawData];

    NSData *serializedIndex = [_numberSerializer serialize:HARDENED_THRESHOLD + index
                                              bufferLength:INT_SERIALIZATION_LENGTH];
    [data appendData:serializedIndex];

    NSMutableData *result = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA512,
           _chainCode.bytes,
           _chainCode.length,
           data.bytes,
           data.length,
           result.mutableBytes);

    NSUInteger keyLength = CC_SHA512_DIGEST_LENGTH / 2;

    NSData *prepare = [data subdataWithRange:NSMakeRange(0, keyLength)];

    _chainCode = [data subdataWithRange:NSMakeRange(keyLength, keyLength)];

    return self;
}

- (nullable instancetype)normalWithIndex:(uint32_t)index error:(NSError*_Nullable*_Nullable)error {
    if (![[self class] validateIndex:index error:error]) {
        return nil;
    }

    return nil;
}

#pragma mark - Private

- (void)initializeMasterExtendedKey:(nonnull NSData*)seed error:(NSError*_Nullable*_Nullable)error {
    NSData *key = [INITIAL_KEY dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableData *data = [NSMutableData dataWithLength:CC_SHA512_DIGEST_LENGTH];

    CCHmac(kCCHmacAlgSHA512,
           key.bytes,
           key.length,
           seed.bytes,
           seed.length,
           data.mutableBytes);

    NSUInteger keyLength = CC_SHA512_DIGEST_LENGTH / 2;

    NSData *privateKeyData = [data subdataWithRange:NSMakeRange(0, keyLength)];
    //IREd25519PrivateKey *privateKey = [[IREd25519PrivateKey alloc] initWithRawData:privateKeyData];

    if (!privateKeyData) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Private key creation failed"];
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRBIP32HDWalletPrivateKeyFailed
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return;
    }

    //_keypair = [_keyFactory deriveFromPrivateKey: privateKey];

    if (!_keypair) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Keypair creation failed"];
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRBIP32HDWalletKeypairFailed
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return;
    }

    _chainCode = [data subdataWithRange:NSMakeRange(keyLength, keyLength)];

}

#pragma mark - Helpers

+ (BOOL)validateIndex:(uint32_t)index error:(NSError*_Nullable*_Nullable)error {
    if (index >= HARDENED_THRESHOLD) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Index must be between 0 and 2^31"];
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRBIP32HDWalletInvalidIndex
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return false;
    } else {
        return true;
    }
}

@end
