//
//  IRCryptoKeypair.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#import <Foundation/Foundation.h>
#import "IRPublicKey.h"
#import "IRPrivateKey.h"

@protocol IRCryptoKeypairProtocol

- (_Nonnull id<IRPublicKeyProtocol>)publicKey;
- (_Nonnull id<IRPrivateKeyProtocol>)privateKey;

@end

@interface IRCryptoKeypair : NSObject<IRCryptoKeypairProtocol>

- (instancetype)initPublicKey:(_Nonnull id<IRPublicKeyProtocol>)publicKey
                   privateKey:(_Nonnull id<IRPrivateKeyProtocol>)privateKey;

@end
