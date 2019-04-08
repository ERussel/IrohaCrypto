//
//  NSData+Hex.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 23/10/2018.
//

#import <Foundation/Foundation.h>

@interface NSData (Hex)

- (nullable instancetype)initWithHexString:(nonnull NSString*)hexString;

- (nonnull NSString*)toHexString;

@end
