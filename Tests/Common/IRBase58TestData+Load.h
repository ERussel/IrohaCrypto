//
//  IRBase58TestData+Load.h
//  IrohaCryptoTests
//
//  Created by Ruslan Rezin on 01.07.2020.
//  Copyright © 2020 Ruslan Rezin. All rights reserved.
//

#import "IRBase58TestData.h"

typedef NS_ENUM(NSUInteger, IRBase58TestDataLoadingError) {
    IRBase58TestDataLoadingFormat,
    IRBase58TestDataLoadingInvalidFilename
};

@interface IRBase58TestData (Load)

+ (nonnull NSArray<IRBase58TestData*>*)loadFromFilename:(nonnull NSString*)filename
                                                  error:(NSError*_Nullable*_Nullable)error;

@end
