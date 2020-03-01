//
//  IRECC255k1PrivateKey.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 28.02.2020.
//

#import "IRSECP256k1PrivateKey.h"

@interface IRSECP256k1PrivateKey()

@property(copy, nonatomic)NSData *rawData;

@end

@implementation IRSECP256k1PrivateKey

- (nullable instancetype)initWithRawData:(NSData *)data {
    if (data.length != [[self class] length]) {
        return nil;
    }

    self = [super init];

    if (self) {
        self.rawData = data;
    }

    return self;
}

+ (NSUInteger)length {
    return 32;
}

@end
