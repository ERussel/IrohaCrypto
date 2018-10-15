//
//  NSData+SHA3.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 14/10/2018.
//

#import "NSData+SHA3.h"
#import "sha256.h"
#import "sha512.h"

static const int SHA3_256_SIZE = 32;
static const int SHA3_512_SIZE = 64;

@implementation NSData (SHA3)

- (nullable NSData *)sha3:(Sha3Variant)variant {
    int result = 0;
    int size = 0;
    unsigned char *hash = NULL;

    switch (variant) {
        case sha256Variant:
            size = SHA3_256_SIZE;
            hash = malloc(size * sizeof(unsigned char));
            result = sha256(hash, self.bytes, self.length);
            break;
        case sha512Variant:
            size = SHA3_512_SIZE;
            hash = malloc(size * sizeof(unsigned char));
            result = sha512(hash, self.bytes, self.length);
    }

    NSData *hashData = [[NSData alloc] initWithBytes:hash length:size];

    free(hash);

    if (result == 0) {
        return nil;
    }

    return hashData;
}

@end
