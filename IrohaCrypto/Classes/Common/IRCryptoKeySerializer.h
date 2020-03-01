//
//  IRCryptoKeySerializer.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 29.02.2020.
//

#import <Foundation/Foundation.h>
#import "IRCryptoKey.h"

@protocol IRCryptoKeySerializerProtocol <NSObject>

- (nullable NSData*)serialize:(nonnull id<IRCryptoKeyProtocol>)key
                        error:(NSError*_Nullable*_Nullable)error;

@end
