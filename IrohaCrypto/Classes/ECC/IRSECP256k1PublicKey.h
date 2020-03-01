//
//  IRECC255k1PublicKey.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#import <Foundation/Foundation.h>
#import "IRCryptoKey.h"

@interface IRSECP256k1PublicKey : NSObject<IRPublicKeyProtocol>

+ (NSUInteger)length;

@end
