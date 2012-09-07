//
//  Address_Type.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 07/09/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Address_Type : NSManagedObject

@property (nonatomic, retain) NSString * a_id;
@property (nonatomic, retain) NSString * type;

@end
