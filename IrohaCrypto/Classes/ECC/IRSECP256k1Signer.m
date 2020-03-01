//
//  IRECC255k1Signer.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 08/10/2018.
//

#import "IRSECP256k1Signer.h"
#import "IRSECP256k1Signature.h"
#import <ECC256k1/secp256k1.h>
#import "IRSECP256k1Constants.h"

@interface IRSECP256k1Signer()

@property(strong, nonatomic)_Nonnull id<IRPrivateKeyProtocol> privateKey;
@property(nonatomic)secp256k1_context *context;

@end

@implementation IRSECP256k1Signer

#pragma mark - Initialization

- (void)dealloc {
    secp256k1_context_destroy(_context);
}

- (nullable instancetype)initWithPrivateKey:(id<IRPrivateKeyProtocol> _Nonnull)privateKey {
    self = [super init];
    
    if (self) {
        self.privateKey = privateKey;

        _context = secp256k1_context_create(SECP256K1_CONTEXT_SIGN);
    }

    return self;
}

#pragma mark - IRSigner

- (nullable id<IRSignatureProtocol>)sign:(nonnull NSData*)originalData {
    secp256k1_ecdsa_signature signatureRaw;

    int result = secp256k1_ecdsa_sign(_context,
                                      &signatureRaw,
                                      originalData.bytes,
                                      _privateKey.rawData.bytes,
                                      NULL,
                                      NULL);

    if (result != SECP256k1_SUCCESS) {
        return nil;
    }

    NSData *data = [NSData dataWithBytes:signatureRaw.data length:[IRSECP256k1Signature length]];

    return [[IRSECP256k1Signature alloc] initWithRawData: data];
}

@end
