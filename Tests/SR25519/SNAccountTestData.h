//
//  SNAccountTestData.h
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 26.06.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNAccountTestData : NSObject

@property(strong, nonatomic, readonly)NSString * _Nonnull mnemonic;
@property(strong, nonatomic, readonly)NSString * _Nonnull seed;
@property(strong, nonatomic, readonly)NSString * _Nonnull publicKey;

- (nonnull instancetype)initWithMnemonic:(nonnull NSString*)mnemonic
                                    seed:(nonnull NSString*)seed
                               publicKey:(nonnull NSString*)publicKey;

@end
