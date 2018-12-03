//
//  NSData+Hex.m
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 23/10/2018.
//

#import "NSData+Hex.h"

@implementation NSData (Hex)

- (instancetype)initWithHexString:(nonnull NSString*)hexString {
    NSUInteger length = [hexString length];

    if (length % 2 != 0) {
        return nil;
    }

    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"abcdefABCDEF"];
    [characterSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    [characterSet invert];

    if ([hexString rangeOfCharacterFromSet:characterSet].location != NSNotFound) {
        return nil;
    }

    uint8_t *bytes = malloc(sizeof(uint8_t) * length / 2);

    const char* cString = [hexString cStringUsingEncoding:NSASCIIStringEncoding];

    for(int index = 0; index + 2 <= length; index += 2) {
        sscanf(&cString[index], "%02" SCNx8, &bytes[index / 2]);
    }

    return [self initWithBytesNoCopy:bytes length:length / 2];
}

- (nonnull NSString*)toHexString {
    NSUInteger length = [self length];

    char *cString = malloc(sizeof(char) * 2 * length + 1);

    uint8_t *bytes = (uint8_t*)[self bytes];

    for (int index = 0; index < length; index++) {
        sprintf(&cString[2 * index], "%02x", bytes[index]);
    }

    cString[2*length] = '\0';

    NSString *result = [[NSString alloc] initWithCString:cString encoding:NSASCIIStringEncoding];

    free(cString);

    return result;
}

@end
