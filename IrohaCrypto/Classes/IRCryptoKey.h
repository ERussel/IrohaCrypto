//
//  IRCryptoKey.h
//  Pods
//
//  Created by Ruslan Rezin on 07/10/2018.
//

#ifndef IRCryptoKey_h
#define IRCryptoKey_h

@protocol IRCryptoKeyProtocol

- (nullable instancetype)initWithRawData:(nonnull NSData*)data;
- (nonnull NSData*)rawData;

@end

#endif /* IRCryptoKey_h */
