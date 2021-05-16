//
//  GostPrivateKey.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 15.05.2021.
//

#import "GostPrivateKey.h"
#import "GostEvpKey.h"
#import "GostError.h"
#include "gost_lcl.h"

#define PEM_PRIV_LEN 144

@interface GostPrivateKey()<GostEvpKeyProtocol>

@property(nonatomic)NSData * _Nonnull rawData;

@end

@implementation GostPrivateKey

- (nullable instancetype)initWithRawData:(nonnull NSData*)data error:(NSError*_Nullable*_Nullable)error {
    if ([data length] != PEM_PRIV_LEN) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Invalid private key size: expected %@ and actual %@", @(PEM_PRIV_LEN), @([data length])];
            *error = [GostPrivateKey createErrorWithMessage: message];
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
            *error = [GostPrivateKey createErrorWithMessage:@"Unexpected nil private key"];
        }

        return nil;
    }

    NSData *rawData = [GostPrivateKey encodePrivateKey:key error:error];
    if (!rawData) {
        return nil;
    }

    return [[GostPrivateKey alloc] initWithRawData:rawData error:error];
}

- (nonnull EVP_PKEY*)toEVPKeyWithError:(NSError*_Nullable*_Nullable)error {
    return [GostPrivateKey decodePrivateKey:_rawData error:error];
}

+ (nullable NSData*)encodePrivateKey:(EVP_PKEY*)evpKey error:(NSError*_Nullable*_Nullable)error {
    BIO *bp;
    bp = BIO_new(BIO_s_mem());
    if (bp == NULL) {
        if (error) {
            *error = [GostPrivateKey createErrorWithMessage:@"Private key serialization setup failed"];
        }

        return nil;
    }
    int err_code = PEM_write_bio_PrivateKey(bp, evpKey, NULL, NULL, 0, 0, NULL);
    if (err_code != ENGINE_SUCCESS) {
        BIO_free(bp);

        if (error) {
            *error = [GostPrivateKey createErrorWithMessage:@"Private key PEM writer failed"];
        }

        return nil;
    }

    uint8_t outbuf[PEM_PRIV_LEN];

    int bytes_read = BIO_read(bp, outbuf, PEM_PRIV_LEN);
    if (bytes_read < PEM_PRIV_LEN) {

        if (error) {
            *error = [GostPrivateKey createErrorWithMessage:@"Invalid private key length"];
        }

        return nil;
    }

    BIO_free(bp);

    return [NSData dataWithBytes:outbuf length:PEM_PRIV_LEN];
}

+ (EVP_PKEY*)decodePrivateKey:(NSData*)data error:(NSError*_Nullable*_Nullable)error {
    BIO *bp;
    bp = BIO_new(BIO_s_mem());
    if (bp == NULL) {
        if (error) {
            *error = [GostPrivateKey createErrorWithMessage:@"Private key decoder setup failed"];
        }

        return NULL;
    }
    int bytes_written = BIO_write(bp, [data bytes], PEM_PRIV_LEN);
    if (bytes_written < PEM_PRIV_LEN) {
        BIO_free(bp);

        if (error) {
            *error = [GostPrivateKey createErrorWithMessage:@"Private key decoding failed"];
        }

        return NULL;
    }

    EVP_PKEY *key = NULL;
    PEM_read_bio_PrivateKey(bp, &key, 0, 0);

    if (!key && error) {
        *error = [GostPrivateKey createErrorWithMessage:@"Private key init faled after decoding"];
    }

    BIO_free(bp);

    return key;
}

+ (NSError*)createErrorWithMessage:(NSString*)message {
    return [NSError errorWithDomain:NSStringFromClass([self class])
                               code:GostPrivateKeyCode
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end
