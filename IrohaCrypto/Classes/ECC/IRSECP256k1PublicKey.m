//
//  IRECC255k1PublicKey.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 28.02.2020.
//

#import "IRSECP256k1PublicKey.h"

@interface IRSECP256k1PublicKey()

@property(copy, nonatomic)NSData *rawData;

@end

@implementation IRSECP256k1PublicKey

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
    return 64;
}

@end
