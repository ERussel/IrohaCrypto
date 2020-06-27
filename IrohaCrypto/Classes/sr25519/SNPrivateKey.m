//
//  SNPrivateKey.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 23.06.2020.
//

#import "SNPrivateKey.h"
#import "sr25519.h"

@interface SNPrivateKey()

@property(copy, nonatomic)NSData *rawData;

@end

@implementation SNPrivateKey

- (nullable instancetype)initWithRawData:(nonnull NSData *)data
                                   error:(NSError * _Nullable __autoreleasing * _Nullable)error {
    if ([data length] != SR25519_SECRET_SIZE) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Invalid raw data length %@ but expected %@",
                                 @([data length]), @(SR25519_SECRET_SIZE)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:IRCryptoKeyErrorInvalidRawData
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    self = [super init];

    if (self) {
        self.rawData = data;
    }

    return self;
}

@end
