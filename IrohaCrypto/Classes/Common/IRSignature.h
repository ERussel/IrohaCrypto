//
//  IRSignature.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 08/10/2018.
//

#import <Foundation/Foundation.h>
#import "IRCryptoKey.h"

@protocol IRSignatureProtocol

- (nullable instancetype)initWithRawData:(nonnull NSData*)data;
- (nonnull NSData*)rawData;

@end

@protocol IRSignatureCreatorProtocol

- (id<IRSignatureProtocol> _Nullable)sign:(nonnull NSData*)originalData;

@end

@protocol IRSignatureVerifierProtocol <NSObject>

- (BOOL)verify:(id<IRSignatureProtocol> _Nonnull)signature
forOriginalData:(nonnull NSData*)originalData
usingPublicKey:(id<IRPublicKeyProtocol> _Nonnull)publicKey;

@end
