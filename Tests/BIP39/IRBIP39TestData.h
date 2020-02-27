//
//  IRBIP39TestData.h
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 27.02.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRBIP39TestData : NSObject

@property(strong, nonatomic, readonly)NSString * _Nonnull entropy;
@property(strong, nonatomic, readonly)NSString * _Nonnull mnemonic;
@property(strong, nonatomic, readonly)NSString * _Nonnull seed;

- (nonnull instancetype)initWithEntropy:(nonnull NSString*)entropy
                               mnemonic:(nonnull NSString*)mnemonic
                                   seed:(nonnull NSString*)seed;

@end
