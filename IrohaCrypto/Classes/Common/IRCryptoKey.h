//
//  IRCryptoKey.h
//  Pods
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#import <Foundation/Foundation.h>

@protocol IRCryptoKeyProtocol

- (nullable instancetype)initWithRawData:(nonnull NSData*)data;
- (nonnull NSData*)rawData;

@end

@protocol IRPrivateKeyProtocol <IRCryptoKeyProtocol>

@end

@protocol IRPublicKeyProtocol <IRCryptoKeyProtocol>

@end
