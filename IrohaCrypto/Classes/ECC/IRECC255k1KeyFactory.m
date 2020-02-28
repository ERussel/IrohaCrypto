//
//  IRECC255k1KeyFactory.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 28.02.2020.
//

#import "IRECC255k1KeyFactory.h"
#import "IRECC255k1PrivateKey.h"
#import "IRECC255k1PublicKey.h"
#import <ECC256k1/secp256k1.h>
#import "IRECCConstants.h"

@interface IRECC255k1KeyFactory()

@property(nonatomic)secp256k1_context *context;

@end

@implementation IRECC255k1KeyFactory

#pragma mark - Initialize

- (void)dealloc {
    secp256k1_context_destroy(_context);
}

- (instancetype)init {
    if (self = [super init]) {
        _context = secp256k1_context_create(SECP256K1_CONTEXT_SIGN);
    }

    return self;
}

#pragma mark - IRKeyFactory

- (id<IRCryptoKeypairProtocol> _Nullable)createRandomKeypair {
    NSMutableData *privateKeyData = [NSMutableData dataWithLength:[IRECC255k1PrivateKey length]];

    int result = SecRandomCopyBytes(kSecRandomDefault, privateKeyData.length, privateKeyData.mutableBytes);

    if (result != errSecSuccess) {
        return nil;
    }

    IRECC255k1PrivateKey *privateKey = [[IRECC255k1PrivateKey alloc] initWithRawData:privateKeyData];

    if (!privateKey) {
        return nil;
    }

    return [self deriveFromPrivateKey:privateKey];
}

- (id<IRCryptoKeypairProtocol> _Nullable)deriveFromPrivateKey:(nonnull id<IRPrivateKeyProtocol>)privateKey {
    secp256k1_pubkey publicKeyRaw;

    int result = secp256k1_ec_pubkey_create(_context, &publicKeyRaw, privateKey.rawData.bytes);

    if (result != ECC_SUCCESS) {
        return nil;
    }

    NSData *publicKeyData = [NSData dataWithBytes:publicKeyRaw.data length:[IRECC255k1PublicKey length]];

    IRECC255k1PublicKey *publicKey = [[IRECC255k1PublicKey alloc] initWithRawData:publicKeyData];

    if (!publicKey) {
        return nil;
    }

    return [[IRCryptoKeypair alloc] initPublicKey:publicKey privateKey:privateKey];
}

@end
