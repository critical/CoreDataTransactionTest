//
//  ZOFDetailViewController.m
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 27/08/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFDetailViewController.h"

@interface ZOFDetailViewController ()
- (void)configureView;
@end

@implementation ZOFDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd/MM/yyyy"];
        NSString *firstName = [self.detailItem valueForKey:@"firstname"];
        NSString *lastName = [self.detailItem valueForKey:@"lastname"];
        NSDate *birthDate = [self.detailItem valueForKey:@"birthdate"];
        NSString *person = [NSString stringWithFormat:@"%@ %@, %@", firstName, lastName, [df stringFromDate:birthDate]];
        self.detailDescriptionLabel.text = [person copy];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
