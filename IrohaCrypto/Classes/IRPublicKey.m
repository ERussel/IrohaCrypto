//
//  IRPublicKey.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#import "IRPublicKey.h"
#import "ed25519.h"

@interface IREd25519PublicKey()

@property(copy, nonatomic)NSData *rawData;

@end

@implementation IREd25519PublicKey

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
