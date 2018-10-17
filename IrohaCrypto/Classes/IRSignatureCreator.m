//
//  IRSignatureCreator.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 08/10/2018.
//

#import "IRSignatureCreator.h"
#import "ed25519.h"

@interface IREd25519Sha512Signer()

@property(strong, nonatomic)_Nonnull id<IRPrivateKeyProtocol> privateKey;

@end

@implementation IREd25519Sha512Signer

- (nullable instancetype)initWithPrivateKey:(id<IRPrivateKeyProtocol> _Nonnull)privateKey {
    self = [super init];
    
    if (self) {
        self.privateKey = privateKey;
    }

    return self;
}

- (nullable IREd25519Sha512Signature *)sign:(nonnull NSData*)originalData {
    private_key_t private_key;
    public_key_t public_key;

    memcpy(private_key.data, _privateKey.rawData.bytes, ed25519_privkey_SIZE);

    ed25519_derive_public_key(&private_key, &public_key);

    signature_t signature;

    ed25519_sign(&signature, originalData.bytes, originalData.length, &public_key, &private_key);

    NSData *signatureData = [[NSData alloc] initWithBytes:signature.data
                                                   length:ed25519_signature_SIZE];


    return [[IREd25519Sha512Signature alloc] initWithRawData:signatureData];
}

@end
