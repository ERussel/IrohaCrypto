//
//  NSData+SHA3.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 14/10/2018.
//

#import "NSData+Blake2s.h"
#import "blake2s.h"

static const int BLAKE_MAX_SIZE = 32;

@implementation NSData (SHA3)

- (nullable NSData *)blake2s:(NSUInteger)length error:(NSError*_Nullable*_Nullable)error {
    if (length > BLAKE_MAX_SIZE) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Length must be not greater then %@", @(BLAKE_MAX_SIZE)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRBlake2sInvalidLength
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        
        return nil;
    }

    uint8_t hash[length];

    int result = blake2s(hash, length, NULL, 0, [self bytes], [self length]);

    if (result != 0) {
        if (error) {
            NSString *message = @"Unexpected error";
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRBlake2sAlgoFailed
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    return [NSData dataWithBytes:hash length:length];
}

- (nullable NSData *)blake2sWithError:(NSError*_Nullable*_Nullable)error {
    return [self blake2s:BLAKE_MAX_SIZE error:error];
}

@end
