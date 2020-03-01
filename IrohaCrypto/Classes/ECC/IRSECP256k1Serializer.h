//
//  IRSECP256k1CompressedSerializer.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 29.02.2020.
//

#import <Foundation/Foundation.h>
#import "IRCryptoKeySerializer.h"

@interface IRSECP256k1Serializer : NSObject<IRCryptoKeySerializerProtocol>

@property(nonatomic, readonly)BOOL compressed;

- (nonnull instancetype)initWithCompressed:(BOOL)compressed;

@end
