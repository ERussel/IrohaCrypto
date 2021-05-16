//
//  GostPublicKey.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 15.05.2021.
//

#import "GostPublicKey.h"
#import "GostEvpKey.h"
#import "GostError.h"
#include "gost_lcl.h"

#define PEM_PUB_LEN 182

@interface GostPublicKey()<GostEvpKeyProtocol>

@property(nonatomic)NSData * _Nonnull rawData;

@end

@implementation GostPublicKey

- (nullable instancetype)initWithRawData:(nonnull NSData*)data error:(NSError*_Nullable*_Nullable)error {
    if ([data length] != PEM_PUB_LEN) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Invalid public key size: expected %@ and actual %@", @(PEM_PUB_LEN), @([data length])];
            *error = [GostPublicKey createErrorWithMessage: message];
        }

        return nil;
    }

    if (self = [super init]) {
        _rawData = data;
    }

    return self;
}

- (nonnull NSData*)rawData {
    return _rawData;
}

+ (nullable instancetype)createFromEVP:(nonnull EVP_PKEY*)key error:(NSError*_Nullable*_Nullable)error {
    if (key == NULL) {
        if (error) {
            *error = [GostPublicKey createErrorWithMessage:@"Unexpected nil public key"];
        }

        return nil;
    }

    NSData *rawData = [GostPublicKey encodePublicKey:key error:error];

    if (!rawData) {
        return nil;
    }

    return [[GostPublicKey alloc] initWithRawData:rawData error:error];
}

- (nonnull EVP_PKEY*)toEVPKeyWithError:(NSError*_Nullable*_Nullable)error {
    return [GostPublicKey decodePublicKey:_rawData error:error];
}

+ (nullable NSData*)encodePublicKey:(EVP_PKEY*)evpKey error:(NSError*_Nullable*_Nullable)error {
    BIO *bp;
    bp = BIO_new(BIO_s_mem());
    if (bp == NULL) {
        if (error) {
            *error = [GostPublicKey createErrorWithMessage:@"Public key serialization setup failed"];
        }

        return nil;
    }
    int err_code = PEM_write_bio_PUBKEY(bp, evpKey);
    if (err_code != ENGINE_SUCCESS) {
        BIO_free(bp);

        if (error) {
            *error = [GostPublicKey createErrorWithMessage:@"Public key PEM writer failed"];
        }

        return nil;
    }

    uint8_t outbuf[PEM_PUB_LEN];

    int bytes_read = BIO_read(bp, outbuf, PEM_PUB_LEN);
    if (bytes_read < PEM_PUB_LEN) {

        if (error) {
            *error = [GostPublicKey createErrorWithMessage:@"Invalid public key length"];
        }

        return nil;
    }

    BIO_free(bp);

    return [NSData dataWithBytes:outbuf length:PEM_PUB_LEN];
}

+ (EVP_PKEY*)decodePublicKey:(NSData*)data error:(NSError*_Nullable*_Nullable)error {
    BIO *bp;
    bp = BIO_new(BIO_s_mem());
    if (bp == NULL) {
        if (error) {
            *error = [GostPublicKey createErrorWithMessage:@"Public key decoder setup failed"];
        }

        return NULL;
    }
    int bytes_written = BIO_write(bp, [data bytes], [data length]);
    if (bytes_written < PEM_PUB_LEN) {
        BIO_free(bp);

        if (error) {
            *error = [GostPublicKey createErrorWithMessage:@"Public key decoding failed"];
        }

        return NULL;
    }

    EVP_PKEY *key = NULL;
    PEM_read_bio_PUBKEY(bp, &key, 0, 0);

    if (!key && error) {
        *error = [GostPublicKey createErrorWithMessage:@"Public key init faled after decoding"];
    }

    BIO_free(bp);

    return key;
}

+ (NSError*)createErrorWithMessage:(NSString*)message {
    return [NSError errorWithDomain:NSStringFromClass([self class])
                               code:GostPublicKeyCode
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end
