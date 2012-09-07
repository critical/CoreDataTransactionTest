//
//  Address.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 07/09/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Address : NSManagedObject

@property (nonatomic, retain) NSString * a_id;
@property (nonatomic, retain) NSString * street;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * id_person;
@property (nonatomic, retain) NSString * id_addr_type;

@end
