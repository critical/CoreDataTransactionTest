//
//  ZOFCycleSelectOperation.m
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 20/10/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFCycleSelectOperation.h"
#import "ZOFMocController.h"

NSString * const ZOFCycleSelectOperationEndNotification = @"CycleSelectEndNotification";

@implementation ZOFCycleSelectOperation

@synthesize numberOfSelect = _numberOfSelect;
@synthesize name = _name;

#pragma mark - Lifecycle

- (id)init
{
    NSLog(@"Invoke initWithServiceDb:");
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}


- (id)initWithServiceDb:(ZOFServiceDb *)serviceDb
{
    if (self = [super init]) {
        _serviceDb = serviceDb;
        _numberOfSelect = 1;
    }
    return self;
}


#pragma mark - Perform operation

- (void)main{
    @autoreleasepool {
        NSLog(@"Perform operation with name: %@", _name);
        NSManagedObjectContext *newContext = [[ZOFMocController sharedInstance] beginTransaction];
        if (self.isCancelled) {
            return;
        }
        if (_numberOfSelect <= 0) {
            _numberOfSelect = 10;
        }
        if (self.isCancelled) {
            return;
        }
        for (int i = 0; i < _numberOfSelect; i++) {
            [_serviceDb fetchBeanName:@"ZOFAddressTypeBean"  inContext:newContext withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"type", @"Residenza"]];
            [_serviceDb fetchBeanName:@"ZOFPersonBean"  inContext:newContext withPredicate:[NSPredicate predicateWithFormat:@"%K == %@", @"lastEvent", @"Videochat su Facebook"]];
        }
        [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
            NSString *stringInfo = [NSString stringWithFormat:@"ZOFCycleSelectOperation %@ end with %d cycles", _name, _numberOfSelect];
            [[NSNotificationCenter defaultCenter] postNotificationName:ZOFCycleSelectOperationEndNotification object:stringInfo];
        }];
    }
}

@end
