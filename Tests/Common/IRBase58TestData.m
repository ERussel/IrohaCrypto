#import "IRBase58TestData.h"

@implementation IRBase58TestData

- (nonnull instancetype)initWithHex:(nonnull NSString*)hex
                             base58:(nonnull NSString*)base58 {
    if (self = [super init]) {
        _hex = hex;
        _base58 = base58;
    }

    return self;
}

@end
