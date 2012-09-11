//
//  ZOFServiceDb.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 09/09/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZOFBaseBean, ZOFMocController, ZOFMapper;

@interface ZOFServiceDb : NSObject {
    @private
    ZOFMocController *_moc;
    ZOFMapper *_mapper;
}

+ (id)sharedInstance;

- (id)fetchBeanName:(NSString *)beanName withPredicate:(NSPredicate *)predicate;
- (BOOL)saveBean:(ZOFBaseBean *)bean error:(NSError *)error;
- (BOOL)deleteBean:(ZOFBaseBean *)bean error:(NSError *)error;
- (BOOL)updateBean:(ZOFBaseBean *)bean error:(NSError *)error;

@end
