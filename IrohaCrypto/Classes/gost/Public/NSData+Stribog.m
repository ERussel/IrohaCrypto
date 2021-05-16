//
//  NSData+SHA3.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 14/10/2018.
//

#import "NSData+Blake2.h"
#import "gosthash2012.h"

@implementation NSData (Stribog)

- (nullable NSData *)stribogWithError:(NSError*_Nullable*_Nullable)error {
    gost2012_hash_ctx ctx;

    init_gost2012_hash_ctx(&ctx, 256);
    gost2012_hash_block(&ctx, [self bytes], [self length]);

    uint8_t hash[32];

    gost2012_finish_hash(&ctx, hash);

    return [NSData dataWithBytes:hash length:32];
}

@end
