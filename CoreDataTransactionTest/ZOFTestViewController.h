//
//  ZOFTestViewController.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 20/10/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZOFServiceDb.h"

@interface ZOFTestViewController : UIViewController

@property (weak, nonatomic) ZOFServiceDb *serviceDb;
@property (weak, nonatomic) IBOutlet UITextView *listTextView;
@property (weak, nonatomic) IBOutlet UILabel *logLabel;

- (IBAction)startProcessAction:(id)sender;
- (IBAction)loadDataAction:(id)sender;
- (IBAction)startDownloadAction:(id)sender;

@end
