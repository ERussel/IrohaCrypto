//
//  IRSignature.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 08/10/2018.
//

#import <Foundation/Foundation.h>

@protocol IRSignatureProtocol

- (nullable instancetype)initWithRawData:(nonnull NSData*)data;
- (nonnull NSData*)rawData;

@end

@interface IREd25519Sha512Signature : NSObject<IRSignatureProtocol>

@end
