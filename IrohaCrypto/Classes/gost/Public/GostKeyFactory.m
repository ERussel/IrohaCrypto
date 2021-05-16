//
//  GostKeyFactory.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 11.05.2021.
//

#import "GostKeyFactory.h"
#import "GostError.h"
#import "GostEngine.h"
#import "GostPrivateKey.h"
#import "GostPublicKey.h"
#import "GostEvpKey.h"
#include "e_gost_err.h"
#include "gost_lcl.h"

@implementation GostKeyFactory

- (id<IRCryptoKeypairProtocol> _Nullable)createRandomKeypair:(NSError*_Nullable*_Nullable)error {
    ENGINE *engine = [GostEngine globalWithError:error];

    if (!engine) {
        return nil;
    }

    int result;

    EVP_PKEY_CTX *ctx = EVP_PKEY_CTX_new_id(NID_id_GostR3410_2012_256, engine);
    if (!ctx) {
        if (error) {
            *error = [GostKeyFactory createErrorWithMessage:@"Context creation failed"];
        }

        return nil;
    }

    result = EVP_PKEY_keygen_init(ctx);

    if (result != ENGINE_SUCCESS) {
        EVP_PKEY_CTX_free(ctx);

        if (error) {
            *error = [GostKeyFactory createErrorWithMessage:@"Context keygen init"];
        }

        return nil;
    }

    result = EVP_PKEY_CTX_ctrl(ctx, NID_id_GostR3410_2012_256, -1, EVP_PKEY_CTRL_GOST_PARAMSET, NID_id_tc26_gost_3410_2012_256_paramSetA, NULL);

    if (result != ENGINE_SUCCESS) {
        EVP_PKEY_CTX_free(ctx);

        if (error) {
            *error = [GostKeyFactory createErrorWithMessage:@"Context setup failed"];
        }

        return nil;
    }

    EVP_PKEY *key = NULL;
    result = EVP_PKEY_keygen(ctx, &key);

    if (result != ENGINE_SUCCESS) {
        EVP_PKEY_CTX_free(ctx);

        if (error) {
            *error = [GostKeyFactory createErrorWithMessage:@"Context setup failed"];
        }

        return nil;
    }

    GostPrivateKey *privateKey = [GostPrivateKey createFromEVP:key error:error];

    if (!privateKey) {
        EVP_PKEY_free(key);
        EVP_PKEY_CTX_free(ctx);

        return nil;
    }

    GostPublicKey *publicKey = [GostPublicKey createFromEVP:key error:error];

    if (!publicKey) {
        EVP_PKEY_free(key);
        EVP_PKEY_CTX_free(ctx);

        return nil;
    }

    EVP_PKEY_free(key);
    EVP_PKEY_CTX_free(ctx);

    return [[IRCryptoKeypair alloc] initPublicKey:publicKey privateKey:privateKey];
}

- (id<IRCryptoKeypairProtocol> _Nullable)deriveFromPrivateKey:(id<IRPrivateKeyProtocol> _Nonnull)privateKey
                                                        error:(NSError*_Nullable*_Nullable)error {
    if (error) {
        *error = [GostKeyFactory createErrorWithMessage:@"Unsupported"];
    }

    return nil;
}

+ (NSError*)createErrorWithMessage:(NSString*)message {
    return [NSError errorWithDomain:NSStringFromClass([self class])
                               code:GostKeyFactoryCode
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end
