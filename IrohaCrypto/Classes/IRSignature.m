//
//  IRSignature.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 08/10/2018.
//

#import "IRSignature.h"
#import "ed25519.h"

@interface IREd25519Sha512Signature()

@property(copy, nonatomic)NSData *rawData;

@end

@implementation IREd25519Sha512Signature

- (nullable instancetype)initWithRawData:(nonnull NSData *)data {
    if (data.length != ed25519_signature_SIZE) {
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

@end
