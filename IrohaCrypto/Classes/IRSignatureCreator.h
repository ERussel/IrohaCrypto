//
//  IRSignatureCreator.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 08/10/2018.
//

#import <Foundation/Foundation.h>
#import "IRPrivateKey.h"
#import "IRSignature.h"

@protocol IRSignatureCreatorProtocol

- (id<IRSignatureProtocol> _Nullable)sign:(nonnull NSData*)originalData;

@end

@interface IREd25519Sha512Signer : NSObject<IRSignatureCreatorProtocol>

- (nullable instancetype)initWithPrivateKey:(id<IRPrivateKeyProtocol> _Nonnull)privateKey;

@end
