//
//  IRECC255k1Verifier.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 08/10/2018.
//

#import "IRSECP256k1Verifier.h"
#import "IRSECP256k1Signature.h"
#import "IRSECP256k1PublicKey.h"
#import <ECC256k1/secp256k1.h>
#import "IRSECP256k1Constants.h"

@interface IRSECP256k1Verifier()

@property(nonatomic)secp256k1_context *context;

@end

@implementation IRSECP256k1Verifier

#pragma mark - Initialize

- (void)dealloc {
    secp256k1_context_destroy(_context);
}

- (nonnull instancetype)init {
    if (self = [super init]) {
        _context = secp256k1_context_create(SECP256K1_CONTEXT_VERIFY);
    }

    return self;
}

- (BOOL)verify:(id<IRSignatureProtocol> _Nonnull)signature
forOriginalData:(nonnull NSData *)originalData
usingPublicKey:(id<IRPublicKeyProtocol> _Nonnull)publicKey {
    secp256k1_ecdsa_signature signatureRaw;
    memcpy(signatureRaw.data, signature.rawData.bytes, [IRSECP256k1Signature length]);

    secp256k1_pubkey publicKeyRaw;
    memcpy(publicKeyRaw.data, publicKey.rawData.bytes, [IRSECP256k1PublicKey length]);

    int result = secp256k1_ecdsa_verify(_context,
                                        &signatureRaw,
                                        originalData.bytes,
                                        &publicKeyRaw);

    return result == SECP256k1_SUCCESS;
}

@end
