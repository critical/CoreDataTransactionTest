//
//  ZOFTestViewController.m
//  CoreDataTransactionTest
//
//  Created by Fabio Gomiero on 20/10/12.
//  Copyright (c) 2012 01Factory. All rights reserved.
//

#import "ZOFTestViewController.h"
#import "ZOFProcessQueue.h"
#import "ZOFDownloadQueue.h"
#import "ZOFEmulateDownloadOp.h"
#import "ZOFCycleSelectOperation.h"


@interface ZOFTestViewController ()

@property (nonatomic, strong) ZOFProcessQueue *procQueue;
@property (nonatomic, strong) ZOFDownloadQueue *downloadQueue;

- (void)notifyCycleOp:(NSNotification *)notif;
- (void)notifyDownloadOp:(NSNotification *)notif;

@end


@implementation ZOFTestViewController

@synthesize procQueue = _procQueue;
@synthesize serviceDb = _serviceDb;
@synthesize listTextView = _listTextView;
@synthesize logLabel = _logLabel;


#pragma mark - Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _procQueue = [ZOFProcessQueue sharedZOFProcessQueue];
    _downloadQueue = [ZOFDownloadQueue sharedZOFDownloadQueue];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCycleOp:) name:ZOFCycleSelectOperationEndNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyDownloadOp:) name:ZOFEmulateDownloadEndNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setListTextView:nil];
    [self setLogLabel:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZOFCycleSelectOperationEndNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ZOFEmulateDownloadEndNotification object:nil];
    
    [super viewDidUnload];
}


#pragma mark - Action

- (IBAction)startProcessAction:(id)sender
{
    [self operationForProcessQueue];
    NSLog(@"Starting Process...");
    [_procQueue startProcess];
}

- (IBAction)loadDataAction:(id)sender
{
    NSArray *arr = [_serviceDb fetchBeanName:@"ZOFPersonBean" inContext:nil  withPredicate:nil];
    NSString *stringArray = [NSString stringWithFormat:@"%@", arr];
    _listTextView.text = stringArray;
}

- (IBAction)startDownloadAction:(id)sender
{
    assert([NSThread isMainThread]);
    _logLabel.text = @"Starting Download...";
    [_downloadQueue startDownloadWithOperation:[self operationForDownload]];
}


#pragma mark - Notification

- (void)notifyCycleOp:(NSNotification *)notif
{
    NSString *info = [notif object];
    NSRange r = [info rangeOfString:@"ReadOperation"];
    if (r.location != NSNotFound) {
        NSLog(@"Starting another download!");
        [self startDownloadAction:nil];
    }
    NSLog(@"Operation finita. NOTIFICA: %@", info);
}

- (void)notifyDownloadOp:(NSNotification *)notif
{
    NSString *info = [notif object];
    NSLog(@"Download completato. NOTIFICA: %@", info);
    _logLabel.text = [NSString stringWithFormat:@"Download completato. Notifica: %@", info];
}


#pragma mark - Manage operation

- (void)operationForProcessQueue
{
    __autoreleasing ZOFCycleSelectOperation *first = [[ZOFCycleSelectOperation alloc] initWithServiceDb:_serviceDb];
    first.name = @"ReadOperation";
    first.numberOfSelect = 70;
    [_procQueue addOperation:first];
    __autoreleasing ZOFCycleSelectOperation *second = [[ZOFCycleSelectOperation alloc] initWithServiceDb:_serviceDb];
    second.name = @"WriteOperation";
    second.numberOfSelect = 70;
    [second addDependency:first];
    [_procQueue addOperation:second];
    __autoreleasing ZOFCycleSelectOperation *third = [[ZOFCycleSelectOperation alloc] initWithServiceDb:_serviceDb];
    third.name = @"CacheOperation";
    third.numberOfSelect = 80;
    [third addDependency:second];
    [_procQueue addOperation:third];
}

- (NSOperation *)operationForDownload
{
    ZOFEmulateDownloadOp *download = [[ZOFEmulateDownloadOp alloc] initWithServiceDb:_serviceDb];
    download.name = @"DownloadOperation";
    download.numberOfSelect = 100;
    download.sleepInSecond = 7;
    return download;
}

@end
