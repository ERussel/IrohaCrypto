//
//  NSData+SHA3.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 14/10/2018.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IRSha3Variant) {
    IRSha3Variant256,
    IRSha3Variant512
};

@interface NSData (SHA3)

- (nullable NSData *)sha3:(IRSha3Variant)variant;

@end
