//
//  IRBIP39TestData.m
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 27.02.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

#import "IRBIP39TestData.h"

@implementation IRBIP39TestData

- (nonnull instancetype)initWithEntropy:(nonnull NSString*)entropy
                               mnemonic:(nonnull NSString*)mnemonic
                                   seed:(nonnull NSString*)seed {
    if (self = [super init]) {
        _entropy = entropy;
        _mnemonic = mnemonic;
        _seed = seed;
    }

    return self;
}

@end
