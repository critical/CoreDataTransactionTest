//
//  ZOFMapper.m
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 10/09/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFMapper.h"
#import <objc/runtime.h>
#import "XPathQuery.h"
#import "ZOFPersonBean.h"
#import "ZOFAddressBean.h"
#import "ZOFAddressTypeBean.h"

@implementation ZOFMapper


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
        NSString *path = [[NSBundle mainBundle] pathForResource: @"beans" ofType: @"xml"];
        if (![self parseXMLBeansFile:path]) {
            NSLog(@"Error during parse config file: %@", path);
        } else {
            _beanNode = [NSMutableDictionary dictionaryWithCapacity:20];
            [self entityNameFromBeanName:@"ZOFBaseBean"];
            _baseMap = [[[_beanNode objectForKey:@"ZOFBaseBean"] objectForKey:@"properties"] objectAtIndex:0];
        }
    }
    return self;
}


#pragma mark - Public Apis

- (BOOL)parseXMLBeansFile:(NSString *)pathToFile
{
    _beansData = [NSData dataWithContentsOfFile:pathToFile];
    return _beansData != nil ? YES : NO;
}

- (NSString *)entityNameFromBeanName:(NSString *)beanName
{
    NSString *result = nil;
    //NSArray *node = [_beanNode objectForKey:beanName];
    NSDictionary *node = [_beanNode objectForKey:beanName];
    if (node == nil) {
        NSString *xpath = [NSString stringWithFormat:@"//bean[@name='%@']", beanName];
        NSArray *nodes = [self contentOfNodeWithXPath:xpath];
        
        NSMutableDictionary *elements = [NSMutableDictionary dictionaryWithCapacity:2];
        NSString *attrMappedByEntity;
        NSArray *attributes = [[nodes objectAtIndex:0] objectForKey:@"nodeAttributeArray"];
        for (NSDictionary *attribute in attributes) {
            if ([[attribute objectForKey:@"attributeName"] isEqualToString:@"mappedByEntity"]) {
                attrMappedByEntity = [attribute objectForKey:@"nodeContent"];
            }
        }
        NSArray *properties = [self extractDictionaryOfProperties:[[nodes objectAtIndex:0] objectForKey:@"nodeChildArray"]];
        
        if (properties) {
            [elements setObject:properties forKey:@"properties"];
        }
        if (attrMappedByEntity) {
            [elements setObject:attrMappedByEntity forKey:@"mappedByEntity"];
        }
        
        [_beanNode setObject:elements forKey:beanName];
        
        node = [_beanNode objectForKey:beanName];
        
    }
    if (node) {
        result = [node objectForKey:@"mappedByEntity"];
    }
    return result;
}


- (id)mapEntities:(NSArray *)arrayOfEntity intoBeanName:(NSString *)beanName withContext:(NSManagedObjectContext *)ctx
{
    NSArray *beanProperties = [[_beanNode objectForKey:beanName] objectForKey:@"properties"];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[arrayOfEntity count]];
    
    
    for (NSManagedObject *manObj in arrayOfEntity) {
        ZOFBaseBean *bean = [[NSClassFromString(beanName) alloc] init];
        
        for (NSDictionary *attribute in beanProperties) {
            NSString *beanProperty, *beanValue, *entityProp = nil;
            beanProperty = [attribute objectForKey:@"name"];
            if ([attribute objectForKey:@"entity"]) {
                NSString *newEntity = [attribute objectForKey:@"entity"];
                NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", [attribute objectForKey:@"entityFieldFk"], [manObj valueForKey:@"a_id"]];
                beanValue = [self execSubQueryOfEntity:newEntity inContext:ctx withPredicate:pred propertyToExtract:[attribute objectForKey:@"entityField"]];
            } else if ([attribute objectForKey:@"beanName"]) {
                NSString *newBean = [attribute objectForKey:@"beanName"];
                NSString *newEntity = [self entityNameFromBeanName:newBean];
                NSPredicate *pred = nil;
                if ([attribute objectForKey:@"entityField"]) {
                    entityProp = [attribute objectForKey:@"entityField"];
                    pred = [NSPredicate predicateWithFormat:@"%K == %@", @"a_id", [manObj valueForKey:entityProp]];
                } else if ([attribute objectForKey:@"entityFieldFk"] != nil) {
                    entityProp = [attribute objectForKey:@"entityFieldFk"];
                    pred = [NSPredicate predicateWithFormat:@"%K == %@", entityProp, [manObj valueForKey:@"a_id"]];
                }
                beanValue = [self mapEntities:[self execSubQueryOfEntity:newEntity inContext:ctx withPredicate:pred propertyToExtract:nil] intoBeanName:newBean withContext:ctx];

            } else if ([attribute objectForKey:@"entityField"]) {
                entityProp = [attribute objectForKey:@"entityField"];
                beanValue = [manObj valueForKey:entityProp];
            }
            [self bean:bean setValue:beanValue forProperty:beanProperty];
        }
        
        [arr addObject:bean];
    }
    return arr;
}

- (NSString *)propertyOfEntity:(NSString **)entityName fromProperty:(NSString *)beanProp ofBean:(NSString *)beanName
{
    NSString *result = nil;
    NSArray *beanProperties = [[_beanNode objectForKey:beanName] objectForKey:@"properties"];
    if (beanProperties == nil) {
        [self entityNameFromBeanName:beanName];
        beanProperties = [[_beanNode objectForKey:beanName] objectForKey:@"properties"];
    }
    for (NSDictionary *attribute in beanProperties) {
        if ([[attribute objectForKey:@"name"] isEqualToString:beanProp]) {
            if (([attribute objectForKey:@"entityField"] != nil && [attribute count] == 2) ||
                ([attribute objectForKey:@"entityField"] != nil && [attribute objectForKey:@"beanName"] != nil)) {
                *entityName = [[_beanNode objectForKey:beanName] objectForKey:@"mappedByEntity"];
                result = [attribute objectForKey:@"entityField"];
            }
            break;
        }
        
    }
    return result;
}

#pragma mark - Private Apis

- (NSArray *)contentOfNodeWithXPath:(NSString *)xpath
{
    return PerformXMLXPathQuery(_beansData, xpath);
}

- (NSArray *)extractDictionaryOfProperties:(NSArray *)beanProperties
{
    NSMutableArray *properties = [NSMutableArray arrayWithCapacity:[beanProperties count]];
    if (_baseMap) {
        [properties addObject:_baseMap];
    }
    for (NSDictionary *rowProperty in beanProperties) {
        NSArray *attributes = [rowProperty objectForKey:@"nodeAttributeArray"];
        NSMutableDictionary *attrProperties = [NSMutableDictionary dictionaryWithCapacity:[attributes count]];
        for (NSDictionary *attribute in attributes) {
            [attrProperties setObject:[attribute objectForKey:@"nodeContent"]  forKey:[attribute objectForKey:@"attributeName"]];
        }
        [properties addObject:attrProperties];
    }
    return properties;
}


- (void)bean:(id)bean setValue:(id)value forProperty:(NSString *)propertyName
{
    objc_property_t theProperty = class_getProperty([bean class], [propertyName UTF8String]);
    char *typeEncoding = NULL;
    typeEncoding = property_copyAttributeValue(theProperty, "T");
    if ( typeEncoding[0] == '@') {
        Class class = nil;
        if (strlen(typeEncoding) >= 3) {
            char *className = strndup(typeEncoding+2, strlen(typeEncoding)-3);
            class = NSClassFromString([NSString stringWithUTF8String:className]);
            free(className);
        }
        if (![class isSubclassOfClass:[NSArray class]] && [[value class] isSubclassOfClass:[NSArray class]]) {
            value = [value objectAtIndex:0];
        }
    }
    [bean setValue:value forKey:propertyName];
    free(typeEncoding);
}

- (id)execSubQueryOfEntity:(NSString *)entityName inContext:(NSManagedObjectContext *)ctx withPredicate:(NSPredicate *)predicate propertyToExtract:(NSString *)propertyName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:ctx];
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSError *error = nil;
    NSArray *results = [ctx executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    if (propertyName) {
        if ([results count] > 0) {
            return [[results objectAtIndex:0] valueForKey:propertyName];
        }
        return nil;
    } else {
        return results;
    }
}

@end
