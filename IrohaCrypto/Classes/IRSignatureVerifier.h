//
//  IRSignatureVerifier.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 08/10/2018.
//

#import <Foundation/Foundation.h>
#import "IRPublicKey.h"
#import "IRSignature.h"

@protocol IRSignatureVerifierProtocol <NSObject>

- (BOOL)verify:(id<IRSignatureProtocol> _Nonnull)signature
forOriginalData:(NSData*)originalData
usingPublicKey:(id<IRPublicKeyProtocol> _Nonnull)publicKey;

@end

@interface IREd25519Sha512Verifier : NSObject<IRSignatureVerifierProtocol>

@end
