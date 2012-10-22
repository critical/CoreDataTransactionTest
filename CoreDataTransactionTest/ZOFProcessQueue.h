//
//  ZOFProcessQueue.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 20/10/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZOFServiceDb.h"

@interface ZOFProcessQueue : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *opeationsArray;
@property (nonatomic, strong, readonly) NSOperationQueue *queue;

+ (ZOFProcessQueue *)sharedZOFProcessQueue;
- (void)addOperation:(NSOperation *)op;
- (void)startProcess;
- (void)cancellProcess;

@end
