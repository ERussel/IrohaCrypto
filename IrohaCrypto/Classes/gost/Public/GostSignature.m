//
//  GostSignature.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 16.05.2021.
//

#import "GostSignature.h"
#import "GostError.h"

#define SIGNATURE_SIZE 64

@interface GostSignature()

@property(copy, nonatomic)NSData *rawData;

@end

@implementation GostSignature

+ (NSUInteger)size { return SIGNATURE_SIZE; }

- (nullable instancetype)initWithRawData:(nonnull NSData *)data error:(NSError*_Nullable*_Nullable)error {
    if (data.length != SIGNATURE_SIZE) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Raw signature size must be %@ but %@ received",
                                 @(SIGNATURE_SIZE), @(data.length)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                         code:GostSignatureCode
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

