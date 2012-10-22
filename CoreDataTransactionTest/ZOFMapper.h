//
//  ZOFMapper.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 10/09/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZOFMapper : NSObject {
    @private
    NSData *_beansData;
    NSMutableDictionary *_beanNode;
    NSDictionary *_baseMap;
}

+ (id)sharedInstance;

- (BOOL)parseXMLBeansFile:(NSString *)pathToFile;

//
// ritorna il nome dell'entita' principale che mappa il bean.
//
- (NSString *)entityNameFromBeanName:(NSString *)beanName;
//
// il primo parametro passato a nil conterrà al ritorno del metodo il nome dell'entity.
//
- (NSString *)propertyOfEntity:(NSString **)entityName fromProperty:(NSString *)beanProp ofBean:(NSString *)beanName;
- (id)mapEntities:(NSArray *)arrayOfEntity intoBeanName:(NSString *)beanName withContext:(NSManagedObjectContext *)ctx;

@end
