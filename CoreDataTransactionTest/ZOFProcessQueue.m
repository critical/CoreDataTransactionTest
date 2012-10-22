//
//  ZOFProcessQueue.m
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 20/10/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFProcessQueue.h"
#import "CWLSynthesizeSingleton.h"

@implementation ZOFProcessQueue

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(ZOFProcessQueue);
@synthesize queue = _queue;
@synthesize opeationsArray = _opeationsArray;

#pragma mark - Lifecycle

- (id)init {
    if (self = [super init]) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.name = @"com.zof.coredatatransaction.process";
        [_queue setMaxConcurrentOperationCount:1];
        _opeationsArray = [NSMutableArray arrayWithCapacity:5];
    }
    return self;
}

#pragma mark - Public Apis

- (void)addOperation:(NSOperation *)op
{
    if (op != nil) {
        [_opeationsArray addObject:op];
    }
}

- (void)startProcess
{
    if ([_queue operationCount] == 0) {
        [_queue addOperations:_opeationsArray waitUntilFinished:NO];
        [_opeationsArray removeAllObjects];
    } else {
        NSLog(@"Process not started.");
    }
}

- (void)cancellProcess
{
    [_queue cancelAllOperations];
}


@end
