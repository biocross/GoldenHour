//
//  HospitalsTableViewController.m
//  GoldenHour
//
//  Created by Pratham Mehta on 29/10/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "HospitalsTableViewController.h"
#import <MapKit/MapKit.h>

@interface HospitalsTableViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) NSArray *places;

@end

@implementation HospitalsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.manager = [[CLLocationManager alloc] init];
    [self.manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    
    NSString *apiKey = @"AIzaSyBH0_UDW6QuTaYTmpLg4i-6bbc0elMwuB0";
    
    
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&types=health|doctor&sensor=true&key=%@&rankby=distance", location.coordinate.latitude, location.coordinate.longitude, apiKey];
    
    //Formulate the string as a URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    NSLog(@"%@",url);
    // Retrieve the results of the URL.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void) fetchedData:(NSData *) data
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    //NSLog(@"Google Data: %@", places);
    
    self.places = places;
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"hospitalCell" forIndexPath:indexPath];
    
    cell.textLabel.text = [[self.places objectAtIndex:[indexPath row]] objectForKey:@"name"];
    cell.detailTextLabel.text = [[self.places objectAtIndex:[indexPath row]] objectForKey:@"vicinity"];
    
    return cell;
}


@end
