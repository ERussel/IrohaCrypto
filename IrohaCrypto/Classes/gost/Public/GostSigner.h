//
//  GostSigner.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 16.05.2021.
//

#import <Foundation/Foundation.h>
#import "IRCryptoKey.h"
#import "IRSignature.h"

@interface GostSigner : NSObject<IRSignatureCreatorProtocol>

- (nonnull instancetype)initWithPrivateKey:(id<IRPrivateKeyProtocol> _Nonnull)privateKey;

@end
