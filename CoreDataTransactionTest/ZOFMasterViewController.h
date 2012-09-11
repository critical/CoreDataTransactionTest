//
//  ZOFMasterViewController.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 27/08/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "ZOFServiceDb.h"

@interface ZOFMasterViewController : UITableViewController {
    ZOFServiceDb *_serviceDb;
}

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
