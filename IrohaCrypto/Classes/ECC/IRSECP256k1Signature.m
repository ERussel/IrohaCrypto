//
//  IRECC255k1Signature.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 08/10/2018.
//

#import "IRSECP256k1Signature.h"
#import "IRSECP256k1Constants.h"

@interface IRSECP256k1Signature()

@property(copy, nonatomic)NSData *rawData;

@end

@implementation IRSECP256k1Signature

- (nullable instancetype)initWithRawData:(nonnull NSData *)data {
    if (data.length != [[self class] length]) {
        return nil;
    }

    self = [super init];

    if (self) {
        self.rawData = data;
    }

    return self;
}

- (nonnull NSData *)rawData {
    return _rawData;
}

+ (NSUInteger)length {
    return 64;
}

@end
