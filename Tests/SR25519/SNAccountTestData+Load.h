//
//  SNAccountTestData+Load.h
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 26.06.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

#import "SNAccountTestData.h"

typedef NS_ENUM(NSUInteger, SNAccountTestDataLoadingError) {
    SNAccountTestDataLoadingFormat,
    SNAccountTestDataLoadingInvalidFilename
};

@interface SNAccountTestData (Load)

+ (nonnull NSArray<SNAccountTestData*>*)loadFromFilename:(nonnull NSString*)filename
                                                language:(nonnull NSString*)language
                                                   error:(NSError*_Nullable*_Nullable)error;

@end
