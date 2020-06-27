#import "SNAccountTestData.h"

@implementation SNAccountTestData

- (nonnull instancetype)initWithMnemonic:(nonnull NSString*)mnemonic
                                    seed:(nonnull NSString*)seed
                               publicKey:(nonnull NSString*)publicKey {
    if (self = [super init]) {
        _mnemonic = mnemonic;
        _seed = seed;
        _publicKey = publicKey;
    }

    return self;
}

@end
