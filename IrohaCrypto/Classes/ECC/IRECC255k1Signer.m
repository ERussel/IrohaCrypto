//
//  IRECC255k1Signer.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 08/10/2018.
//

#import "IRECC255k1Signer.h"
#import "IRECC255k1Signature.h"
#import <ECC256k1/secp256k1.h>
#import "IRECCConstants.h"

@interface IRECC255k1Signer()

@property(strong, nonatomic)_Nonnull id<IRPrivateKeyProtocol> privateKey;
@property(nonatomic)secp256k1_context *context;

@end

@implementation IRECC255k1Signer

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

    if (result != ECC_SUCCESS) {
        return nil;
    }

    NSData *data = [NSData dataWithBytes:signatureRaw.data length:[IRECC255k1Signature length]];

    return [[IRECC255k1Signature alloc] initWithRawData: data];
}

@end
