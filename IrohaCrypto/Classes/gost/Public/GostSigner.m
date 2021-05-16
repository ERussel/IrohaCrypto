//
//  GostSigner.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 16.05.2021.
//

#import "GostSigner.h"
#import "GostSignature.h"
#import "GostEvpKey.h"
#import "GostError.h"
#import "NSData+Stribog.h"
#import "GostEngine.h"

@interface GostSigner()

@property(strong, nonatomic)_Nonnull id<IRPrivateKeyProtocol> privateKey;

@end

@implementation GostSigner

- (nonnull instancetype)initWithPrivateKey:(id<IRPrivateKeyProtocol> _Nonnull)privateKey {
    if (self = [super init]) {
        self.privateKey = privateKey;
    }

    return self;
}

- (nullable id<IRSignatureProtocol>)sign:(nonnull NSData*)originalData
                                   error:(NSError*_Nullable*_Nullable)error {
    if (![_privateKey conformsToProtocol:@protocol(GostEvpKeyProtocol)]) {
        if (error) {
            *error = [GostSigner createErrorWithMessage:@"Invalid private key"];
        }
        return nil;
    }

    ENGINE *engine = [GostEngine globalWithError:error];

    if (!engine) {
        return nil;
    }

    EVP_PKEY *evpKey = [(id<GostEvpKeyProtocol>)_privateKey toEVPKeyWithError:error];

    if (!evpKey) {
        return nil;
    }

    EVP_PKEY_CTX* ctx = EVP_PKEY_CTX_new(evpKey, engine);

    if (!ctx) {
        EVP_PKEY_free(evpKey);

        if (error) {
            *error = [GostSigner createErrorWithMessage:@"Signing context creation failed"];
        }

        return nil;
    }

    int result = EVP_PKEY_sign_init(ctx);

    if (result != ENGINE_SUCCESS) {
        EVP_PKEY_free(evpKey);
        EVP_PKEY_CTX_free(ctx);

        if (error) {
            *error = [GostSigner createErrorWithMessage:@"Signing init failed"];
        }

        return nil;
    }

    NSData *hash = [originalData stribogWithError:error];

    if (!hash) {
        EVP_PKEY_free(evpKey);
        EVP_PKEY_CTX_free(ctx);

        if (error) {
            *error = [GostSigner createErrorWithMessage:@"Hashing failed"];
        }

        return nil;
    }

    NSUInteger siglen = [GostSignature size];
    uint8_t signature[siglen];

    result = EVP_PKEY_sign(ctx, signature, &siglen, [hash bytes], [hash length]);

    if (result != ENGINE_SUCCESS) {
        EVP_PKEY_free(evpKey);
        EVP_PKEY_CTX_free(ctx);

        if (error) {
            *error = [GostSigner createErrorWithMessage:@"Signing failed"];
        }

        return nil;
    }

    EVP_PKEY_free(evpKey);
    EVP_PKEY_CTX_free(ctx);

    return [[GostSignature alloc] initWithRawData:[NSData dataWithBytes:signature length:siglen] error:error];
}

+ (NSError*)createErrorWithMessage:(NSString*)message {
    return [NSError errorWithDomain:NSStringFromClass([self class])
                               code:GostPrivateKeyCode
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end
