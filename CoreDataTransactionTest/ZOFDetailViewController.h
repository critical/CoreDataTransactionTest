//
//  ZOFDetailViewController.h
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 27/08/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZOFDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressesLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
