//
//  Person.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 07/09/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSDate * birthdate;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * a_id;

@end
