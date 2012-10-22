//
//  ZOFDownloadQueue.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 20/10/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZOFDownloadQueue : NSObject

@property (nonatomic, strong, readonly) NSOperationQueue *queue;

+ (ZOFDownloadQueue *)sharedZOFDownloadQueue;
- (void)startDownloadWithOperation:(NSOperation *)downloadOp;
- (void)cancellProcess;

@end
