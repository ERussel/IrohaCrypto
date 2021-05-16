//
//  GostSignatureVerifier.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 16.05.2021.
//

#import "GostSignatureVerifier.h"
#import "GostEvpKey.h"
#import "GostError.h"
#import "NSData+Stribog.h"
#import "GostEngine.h"
#import "GostSignature.h"

@implementation GostSignatureVerifier

- (BOOL)verify:(id<IRSignatureProtocol> _Nonnull)signature
forOriginalData:(nonnull NSData *)originalData
usingPublicKey:(id<IRPublicKeyProtocol> _Nonnull)publicKey {

    if (![publicKey conformsToProtocol:@protocol(GostEvpKeyProtocol)]) {
        return false;
    }

    ENGINE *engine = [GostEngine globalWithError:nil];

    if (!engine) {
        return false;
    }

    EVP_PKEY *evpKey = [(id<GostEvpKeyProtocol>)publicKey toEVPKeyWithError:nil];

    if (!evpKey) {
        return nil;
    }

    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new(evpKey, engine);

    if (!ctx) {
        EVP_PKEY_free(evpKey);

        return false;
    }

    int result = EVP_PKEY_verify_init(ctx);

    if (result != ENGINE_SUCCESS) {
        EVP_PKEY_free(evpKey);
        EVP_PKEY_CTX_free(ctx);

        return false;
    }

    NSData *hash = [originalData stribogWithError:nil];

    if (!hash) {
        EVP_PKEY_free(evpKey);
        EVP_PKEY_CTX_free(ctx);

        return false;
    }

    result = EVP_PKEY_verify(ctx, [[signature rawData] bytes], [GostSignature size], [hash bytes], [hash length]);

    EVP_PKEY_free(evpKey);
    EVP_PKEY_CTX_free(ctx);

    return result == ENGINE_SUCCESS;
}

+ (NSError*)createErrorWithMessage:(NSString*)message {
    return [NSError errorWithDomain:NSStringFromClass([self class])
                               code:GostPublicKeyCode
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}


@end
