//
//  ZOFFillDb.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 27/08/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZOFMocController.h"

@interface ZOFFillDb : NSObject {
    @private
    BOOL _opExec;
    NSDateFormatter *_df;
}

@property (strong, nonatomic) ZOFMocController *mocController;

+ (ZOFFillDb *)sharedZOFFillDb;

- (BOOL)operationExec;
- (void)fillDbOfEntity:(NSString *)entityName howManyInsert:(NSInteger)numberOfInsert withSleep:(BOOL)sleeping;

@end
