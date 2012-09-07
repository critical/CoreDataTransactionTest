//
//  NSObject+setValuesForKeysWithJSONDictionary.m
//  01Catalog
//
//  Created by Fabio Gomiero on 24/05/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "NSManagedObject+setValuesForKeysWithJSONDictionary.h"
#import <objc/runtime.h>

@implementation NSManagedObject (setValuesForKeysWithJSONDictionary)

- (void)setValuesForKeysWithJSONDictionary:(NSDictionary *)keyedValues dateFormatter:(NSDateFormatter *)dateFormatter
{
	unsigned int propertyCount;
	objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
	/*
	 This code iterates over self's properties instead of ivars because the backing ivar might have a different name
	 than the property, for example if the class includes something like:
	 
	 @synthesize foo = foo_;
	 
	 In this case what we really want is "foo", not "foo_", since the incoming keys in keyedValues probably
	 don't have the underscore. Looking through properties gets "foo", looking through ivars gets "foo_".
	 */
	for (int i=0; i<propertyCount; i++) {
		objc_property_t property = properties[i];
		const char *propertyName = property_getName(property);
		NSString *keyName = [NSString stringWithUTF8String:propertyName];
        
		id value = [keyedValues objectForKey:keyName];
		if (value != nil) {
			char *typeEncoding = NULL;
			typeEncoding = property_copyAttributeValue(property, "T");
            
			if (typeEncoding == NULL) {
				continue;
			}
			switch (typeEncoding[0]) {
				case '@':
				{
					// Object
					Class class = nil;
					if (strlen(typeEncoding) >= 3) {
						char *className = strndup(typeEncoding+2, strlen(typeEncoding)-3);
						class = NSClassFromString([NSString stringWithUTF8String:className]);
                        free(className);
					}
					// Check for type mismatch, attempt to compensate
					if ([class isSubclassOfClass:[NSString class]] && [value isKindOfClass:[NSNumber class]]) {
						value = [value stringValue];
					} else if ([class isSubclassOfClass:[NSNumber class]] && [value isKindOfClass:[NSString class]]) {
						// If the ivar is an NSNumber we really can't tell if it's intended as an integer, float, etc.
						NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
						[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
						value = [numberFormatter numberFromString:value];
						//[numberFormatter release]; ARC fixing
					} else if ([class isSubclassOfClass:[NSDate class]] && (dateFormatter != nil)) {
                        if ([value isKindOfClass:[NSString class]]) {
                            value = [dateFormatter dateFromString:value];
                        } else if ([value isKindOfClass:[NSNumber class]]) {
                            NSTimeInterval t = [value doubleValue];
                            value = [NSDate dateWithTimeIntervalSince1970:t];
                        } else {
                            value = NULL;
                        }
					} else if ([class isSubclassOfClass:[NSManagedObject class]]) {
                        NSLog(@"Is subclassing of NSManagedObject");
                        if ([value isKindOfClass:[NSDictionary class]] || [value isSubclassOfClass:[NSDictionary class]]) {
                            NSString *aIdVal = [value objectForKey:KEY_A_ID];
                            if (aIdVal != nil && self.managedObjectContext != nil) {
                                NSManagedObject *child = [self retrieveChildOfClassName:[class description] withAId:aIdVal];
                                if (child != nil) {
                                    value = child;
                                } else {
                                    //dovrei inserirlo
                                }
                            }
                        }
                        NSLog(@"Value class %@, value: %@", [value class], value);
                    }
                    
					break;
				}
                    
				case 'i': // int
				case 's': // short
				case 'l': // long
				case 'q': // long long
				case 'I': // unsigned int
				case 'S': // unsigned short
				case 'L': // unsigned long
				case 'Q': // unsigned long long
				case 'f': // float
				case 'd': // double
				case 'B': // BOOL
				{
					if ([value isKindOfClass:[NSString class]]) {
						NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
						[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
						value = [numberFormatter numberFromString:value];
						//[numberFormatter release]; ARC fixing
					}
					break;
				}
                    
				case 'c': // char
				case 'C': // unsigned char
				{
					if ([value isKindOfClass:[NSString class]]) {
						char firstCharacter = [value characterAtIndex:0];
						value = [NSNumber numberWithChar:firstCharacter];
					}
					break;
				}
                    
				default:
				{
					break;
				}
			}
			[self setValue:value forKey:keyName];
			free(typeEncoding);
		}
	}
	free(properties);
}

- (NSManagedObject *)retrieveChildOfClassName:(NSString *)className withAId:(NSString *) aIdVal
{
    NSEntityDescription *entity= [NSEntityDescription entityForName:className inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"a_id = %@", aIdVal]];
    NSError *error;
    NSArray *objs = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if([objs count] > 0) {
        return [objs objectAtIndex:0];
    }
    return nil;
}


- (NSDictionary *)mapKeysAttributes:(NSArray *)keyPaths
{
    NSLog(@"Mapping for obj: %@", [self class]);
    NSMutableDictionary* map = nil;
    unsigned int propertyCount;
	objc_property_t *properties = class_copyPropertyList([self class], &propertyCount);
    
    if (propertyCount > 0 && keyPaths != nil && [keyPaths count] > 0) {
        map = [NSMutableDictionary dictionaryWithCapacity:propertyCount];
        
        for (int i=0; i<propertyCount; i++) {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *attrName = [NSString stringWithUTF8String:propertyName]; //nome field dell'oggetto (formato aaa_bbb_ccc)
            
            NSString *attrInCamelCase = nil;
            
            if ([attrName isEqualToString:KEY_A_ID]) {
                attrInCamelCase = @"id";
            } else if ([attrName isEqualToString:@"is_delete"]) {
                attrInCamelCase = @"isDeleted";
            } else {
                attrInCamelCase = [self fieldNameInCamelCase:attrName];
            }
            
            NSLog(@"attrName: %@, attrInCamelCase: %@", attrName, attrInCamelCase);
            
            
            if (attrInCamelCase != nil) {
                NSUInteger indexInArray = [keyPaths indexOfObject:attrInCamelCase];
                if (indexInArray != NSNotFound) {
                    [map setObject:attrName forKey:attrInCamelCase];
                    //[objectMapping mapKeyPath:attrInCamelCase toAttribute:attrName];
                }
            }
        }
    }
    
    return map;
}

- (NSString *) fieldNameInCamelCase:(NSString const*) objFieldName
{
    NSString *capitalized = [[[NSString stringWithFormat:@"k%@", objFieldName] stringByReplacingOccurrencesOfString:@"_" withString:@" "] capitalizedString];
    return [[capitalized substringFromIndex:1] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
