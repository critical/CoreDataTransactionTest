//
//  ZOFAddressBean.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 07/09/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFBaseBean.h"

@class ZOFAddressTypeBean;

@interface ZOFAddressBean : ZOFBaseBean

@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) ZOFAddressTypeBean *addrType;

@end
