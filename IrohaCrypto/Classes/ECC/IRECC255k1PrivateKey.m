//
//  IRECC255k1PrivateKey.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 28.02.2020.
//

#import "IRECC255k1PrivateKey.h"

@interface IRECC255k1PrivateKey()

@property(copy, nonatomic)NSData *rawData;

@end

@implementation IRECC255k1PrivateKey

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
