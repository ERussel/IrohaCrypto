//
//  IRPublicKey.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#import <Foundation/Foundation.h>
#import "IRCryptoKey.h"

@protocol IRPublicKeyProtocol <IRCryptoKeyProtocol>

@end

@interface IREd25519PublicKey : NSObject<IRPublicKeyProtocol>

@end
