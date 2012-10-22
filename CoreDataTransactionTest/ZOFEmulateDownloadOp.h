//
//  ZOFEmulateDownloadOp.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 20/10/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZOFServiceDb.h"

extern NSString * const ZOFEmulateDownloadEndNotification;

@interface ZOFEmulateDownloadOp : NSOperation {
    @private
    ZOFServiceDb *_serviceDb;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger numberOfSelect;
@property (nonatomic) NSTimeInterval sleepInSecond;

- (id)initWithServiceDb:(ZOFServiceDb *)serviceDb;

@end
