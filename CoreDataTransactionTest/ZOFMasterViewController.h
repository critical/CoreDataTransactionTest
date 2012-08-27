//
//  ZOFMasterViewController.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 27/08/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface ZOFMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
