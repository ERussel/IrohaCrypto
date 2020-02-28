//
//  IRECC255k1PrivateKey.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 28.02.2020.
//

#import <Foundation/Foundation.h>
#import "IRCryptoKey.h"

@interface IRECC255k1PrivateKey : NSObject<IRPrivateKeyProtocol>

+ (NSUInteger)length;

@end
