//
//  IRCryptoKeyFactory.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#import <Foundation/Foundation.h>
#import "IRCryptoKeypair.h"

@protocol IRCryptoKeyFactoryProtocol <NSObject>

- (id<IRCryptoKeypairProtocol> _Nullable)createRandomKeypair;
- (id<IRCryptoKeypairProtocol> _Nullable)deriveFromPrivateKey:(id<IRPrivateKeyProtocol> _Nonnull)privateKey;

@end

@interface IREd25519KeyFactory : NSObject<IRCryptoKeyFactoryProtocol>

@end
