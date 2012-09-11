//
//  ZOFServiceDb.m
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 09/09/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFServiceDb.h"
#import "ZOFMocController.h"
#import "ZOFMapper.h"

@implementation ZOFServiceDb

#pragma mark - Lifecycle

- (id)init
{
    NSLog(@"[ERROR]You cannot use init method.");
    return nil;
}

+ (id)sharedInstance
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initHide];
    });
    return _sharedObject;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (id)initHide
{
    self = [super init];
    if (self) {
        _moc = [ZOFMocController sharedInstance];
        _mapper = [ZOFMapper sharedInstance];
    }
    return self;
}


#pragma mark - Public Apis

- (NSArray *)fetchBeanName:(NSString *)beanName withPredicate:(NSPredicate *)predicate
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:[_mapper entityNameFromBeanName:beanName]
                                              inManagedObjectContext:_moc.managedObjectContext];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    /*
    if (variables) {
        NSString *entityName = nil;
        
        NSString *propOfEntity = [_mapper propertyOfEntity:&entityName fromProperty:[[variables allKeys] objectAtIndex:0]  ofBean:beanName];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", propOfEntity, [[variables allValues] objectAtIndex:0]];
        [request setPredicate:pred];
    }
    */
    
    NSError *error = nil;
    NSArray *results = [_moc.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    if (predicate) {
        return [[_mapper mapEntities:results intoBeanName:beanName] filteredArrayUsingPredicate:predicate];
    } else {
        return [_mapper mapEntities:results intoBeanName:beanName];
    }
}


- (BOOL)saveBean:(ZOFBaseBean *)bean error:(NSError *)error
{
    return NO;
}

- (BOOL)deleteBean:(ZOFBaseBean *)bean error:(NSError *)error
{
    return NO;
}

- (BOOL)updateBean:(ZOFBaseBean *)bean error:(NSError *)error
{
    return NO;
}

@end
