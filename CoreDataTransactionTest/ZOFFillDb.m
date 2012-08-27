//
//  ZOFFillDb.m
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 27/08/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFFillDb.h"

@implementation ZOFFillDb

@synthesize mocController = _mocController;

#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        _opExec = NO;
    }
    return self;
}


#pragma mark - Public Apis

- (void)fillDbOfEntity:(NSString *)entityName howManyInsert:(NSInteger)numberOfInsert withSleep:(BOOL)sleeping
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _opExec = NO;
        if (sleeping) {
            sleep(5);
        }
        NSManagedObjectContext *context = [_mocController beginTransaction];
        NSArray *values = [self createArrayOfObj:entityName howManyInsert:numberOfInsert];
        for (NSDictionary *valueDict in values) {
            NSManagedObjectContext *obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
            [obj setValuesForKeysWithDictionary:valueDict];
        }
        [_mocController endTransaction:context];
        _opExec = YES;
    });
}

- (BOOL)operationExec
{
    @synchronized(self){
        return _opExec;
    }
}

#pragma mark - Private Apis

- (NSMutableArray *)createArrayOfObj:(NSString *)entityName howManyInsert:(NSInteger)numberOfInsert {
    NSMutableArray *objs = [NSMutableArray arrayWithCapacity:numberOfInsert];
    if ([entityName isEqualToString:@"Person"]) {
        for (int i=0; i<numberOfInsert; i++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
            [dict setObject:[NSString stringWithFormat:@"first%d", i] forKey:@"firstname"];
            [dict setObject:[NSString stringWithFormat:@"last%d", i] forKey:@"lastname"];
            [dict setObject:[NSString stringWithFormat:@"t%d", i] forKey:@"title"];
            [dict setObject:[[NSDate date] dateByAddingTimeInterval:(rand()%2)] forKey:@"birthdate"];
            [objs addObject:dict];
        }
    }
    return objs;
}


@end
