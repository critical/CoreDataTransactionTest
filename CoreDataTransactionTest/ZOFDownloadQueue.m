//
//  ZOFDownloadQueue.m
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 20/10/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFDownloadQueue.h"
#import "CWLSynthesizeSingleton.h"

@implementation ZOFDownloadQueue

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(ZOFDownloadQueue);
@synthesize queue = _queue;


#pragma mark - Lifecycle

- (id)init {
    if (self = [super init]) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.name = @"com.zof.coredatatransaction.download";
        [_queue setMaxConcurrentOperationCount:1];
    }
    return self;
}


#pragma mark - Public Apis

- (void)startDownloadWithOperation:(NSOperation *)downloadOp
{
    if ([_queue operationCount] == 0) {
        [_queue addOperation:downloadOp];
    } else {
        NSLog(@"Download not started.");
    }
}

- (void)cancellProcess
{
    [_queue cancelAllOperations];
}

@end
