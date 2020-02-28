//
//  IRPrivateKey.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#import "IRIrohaPrivateKey.h"
#import "ed25519.h"

@interface IRIrohaPrivateKey()

@property(copy, nonatomic)NSData *rawData;

@end

@implementation IRIrohaPrivateKey

- (nullable instancetype)initWithRawData:(NSData *)data {
    if (data.length != ed25519_privkey_SIZE) {
        return nil;
    }

    self = [super init];

    if (self) {
        self.rawData = data;
    }

    return self;
}

@end
