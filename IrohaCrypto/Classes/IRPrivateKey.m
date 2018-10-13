//
//  IRPrivateKey.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#import "IRPrivateKey.h"
#import "ed25519.h"

@interface IREd25519PrivateKey()

@property(nonatomic, copy)NSData *rawData;

@end

@implementation IREd25519PrivateKey

- (nullable instancetype)initWithRawData:(NSData *)data {
    if (data.length != ed25519_privkey_SIZE) {
        return nil;
    }

    if (self = [super init]) {
        self.rawData = data;
    }

    return self;
}

@end
