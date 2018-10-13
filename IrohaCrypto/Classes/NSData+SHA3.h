//
//  NSData+SHA3.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 14/10/2018.
//

#import <Foundation/Foundation.h>

typedef enum {
    sha256Variant,
    sha512Variant
}Sha3Variant;

@interface NSData (SHA3)

- (nullable NSData *)sha3:(Sha3Variant)variant;

@end
