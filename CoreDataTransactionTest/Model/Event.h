//
//  Event.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 08/09/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * id_person;
@property (nonatomic, retain) NSString * a_id;

@end
