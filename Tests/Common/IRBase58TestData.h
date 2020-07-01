//
//  SNBase58TestData.h
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 01.07.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IRBase58TestData : NSObject

@property(strong, nonatomic, readonly)NSString * _Nonnull base58;
@property(strong, nonatomic, readonly)NSString * _Nonnull hex;

- (nonnull instancetype)initWithHex:(nonnull NSString*)hex
                             base58:(nonnull NSString*)base58;

@end
