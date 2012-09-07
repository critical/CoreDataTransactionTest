//
//  ZOFPersonBean.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 07/09/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFBaseBean.h"

@interface ZOFPersonBean : ZOFBaseBean

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSDate *birthdate;
@property (nonatomic, strong) NSString *lastEvent;
@property (nonatomic, strong) NSArray *addresses; //AddressBean's array

@end
