//
//  ZOFFillDb.m
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 27/08/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFFillDb.h"
#import "CWLSynthesizeSingleton.h"

@implementation ZOFFillDb

CWL_SYNTHESIZE_SINGLETON_FOR_CLASS(ZOFFillDb);
@synthesize mocController = _mocController;


#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        _opExec = NO;
        _df = [[NSDateFormatter alloc] init];
        [_df setDateFormat:@"dd/MM/yyyy HH:mm"];
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
        [self loadData:context];
        /*
        NSArray *values = [self createArrayOfObj:entityName howManyInsert:numberOfInsert];
        for (NSDictionary *valueDict in values) {
            NSManagedObjectContext *obj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
            [obj setValuesForKeysWithDictionary:valueDict];
        }
        */
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

- (void)loadData:(NSManagedObjectContext *)context
{
    NSArray *objects = [self importFromFile:@"addrTypes"];
    NSLog(@"Imported address types: %@ \n Saving %@...", objects, @"Address_Type");
    [self saveEntityName:@"Address_Type" dataDict:objects inContext:context];
    
    objects = [self importFromFile:@"persons"];
    NSLog(@"Imported persons: %@ \n Saving %@...", objects, @"Person");
    [self saveEntityName:@"Person" dataDict:objects inContext:context];
    
    objects = [self importFromFile:@"addresses"];
    NSLog(@"Imported addresses: %@ \n Saving %@...", objects, @"Address");
    [self saveEntityName:@"Address" dataDict:objects inContext:context];
    
    objects = [self importFromFile:@"events"];
    NSLog(@"Imported addresses: %@ \n Saving %@...", objects, @"Event");
    [self saveEntityName:@"Event" dataDict:objects inContext:context];
}


#pragma mark - Import file

- (NSArray*) importFromFile:(NSString *)filename
{
    NSError *err = nil;
    NSString* dataPath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:dataPath] options:NSJSONReadingMutableContainers error:&err];
}

#pragma mark - Salvataggio db

- (void) saveEntityName:(NSString *)entityName dataDict:(NSArray *)data inContext:(NSManagedObjectContext *)context
{
    for (NSDictionary *dictionary in data) {
        NSManagedObject *newObj = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        [newObj setValuesForKeysWithJSONDictionary:dictionary dateFormatter:_df];
	}
}


@end
