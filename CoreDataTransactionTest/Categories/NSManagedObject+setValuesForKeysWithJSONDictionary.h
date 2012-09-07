//
//  NSObject+setValuesForKeysWithJSONDictionary.h
//  01Catalog
//
//  Created by Fabio Gomiero on 24/05/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KEY_A_ID    @"a_id"

@interface NSManagedObject (setValuesForKeysWithJSONDictionary)

- (void)setValuesForKeysWithJSONDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter;
- (NSDictionary *)mapKeysAttributes:(NSArray *)keyPaths;

@end
