//
//  IRScryptKeyDeriviation.h
//  IrohaCrypto
//
//  Created by Ruslan Rezin on 27.02.2020.
//

#import <Foundation/Foundation.h>
#import "IRKeyDeriviationFunction.h"

typedef NS_ENUM(NSUInteger, IRScryptKeyDeriviationError) {
    IRScryptFailed
};

@interface IRScryptKeyDeriviation : NSObject<IRKeyDeriviationFunction>

@end
