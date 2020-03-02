#import "IRBIP39KeyDeriviation.h"
#import <CommonCrypto/CommonCrypto.h>

static const NSUInteger ROUND_COUNT = 2048;

@implementation IRBIP39KeyDeriviation

- (nullable NSData*)deriveKeyFrom:(nonnull NSString*)password
                             salt:(nonnull NSData*)salt
                           length:(NSUInteger)length
                            error:(NSError*_Nullable*_Nullable)error {

    NSUInteger passwordLength = [password lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *passwordData = [password UTF8String];

    NSMutableData *key = [NSMutableData dataWithLength:length];

    int result = CCKeyDerivationPBKDF(kCCPBKDF2,
                                      passwordData,
                                      passwordLength,
                                      salt.bytes,
                                      salt.length,
                                      kCCPRFHmacAlgSHA512,
                                      ROUND_COUNT,
                                      key.mutableBytes,
                                      key.length);

    if (result == kCCSuccess) {
        return key;
    } else {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Unexpected pbkdf2 result %@ received", @(result)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRBIP39PBKDF2Failed
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }
}

@end
