//
//  IRPublicKey.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#import "IRIrohaPublicKey.h"
#import "ed25519.h"

@interface IRIrohaPublicKey()

@property(copy, nonatomic)NSData *rawData;

@end

@implementation IRIrohaPublicKey

- (nullable instancetype)initWithRawData:(NSData *)data {
    if (data.length != ed25519_pubkey_SIZE) {
        return nil;
    }

    self = [super init];

    if (self) {
        self.rawData = data;
    }

    return self;
}

@end
