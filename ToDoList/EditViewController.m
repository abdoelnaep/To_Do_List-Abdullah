//
//  EditViewController.m
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import "EditViewController.h"
#import "UpdateViewController.h"
#import "DataModel.h"
#import <UserNotifications/UserNotifications.h>

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    printf("viewDidLoad");
    self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
        self.navigationItem.leftBarButtonItem = newBackButton;
    
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonTapped)];
    
    [self.navigationItem setRightBarButtonItem:editBtn];
    _nameLabel.text = [_detailModelDict objectForKey:@"title"];
    _detailsLabel.text = [_detailModelDict objectForKey:@"detail"];
    _piriorityLabel.text = [_detailModelDict objectForKey:@"prio"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:min a"];
    NSString *datePicker = [dateFormatter stringFromDate:[_detailModelDict objectForKey:@"date"]];
    _dateLabel.text = datePicker;
}
- (void)editButtonTapped {
    
     UpdateViewController *updateVC = [self.storyboard instantiateViewControllerWithIdentifier:@"updateVC"];
    updateVC.editDict = _detailModelDict;
    updateVC.index = self->_index;
    updateVC.indexSearch = _indexSearch;
    updateVC.Update = self;
    updateVC.onDoneBlock = ^(NSMutableDictionary * editDict) {self->_detailModelDict = editDict;
        
        };
    [self.navigationController presentViewController:updateVC animated:YES completion:nil];
    

//updateVC.onDoneBlock = ^(NSMutableDictionary * editDict) {[updateVC dismissViewControllerAnimated:YES completion:^{
//
//        self->_detailModelDict =editDict;
//    }];
//    };
  

}

- (void) back:(UIBarButtonItem *)sender {
    // Perform your custom actions
    // ...
    // Go back to the previous ViewController
    [_UpdateCell updateMehodDic:_selectedModelDict :_index.row :_indexSearch];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:options
    completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (!granted) {
            NSLog(@"Something went wrong");
        }
    }];
    UNMutableNotificationContent *content = [UNMutableNotificationContent new];
    
    content.title = [_selectedModelDict objectForKey:@"title"];
    content.body = [_selectedModelDict objectForKey:@"detail"];
    content.sound = [UNNotificationSound defaultSound];
    NSDate *date = [_selectedModelDict objectForKey:@"date"];
    NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                  components:NSCalendarUnitYear +
                  NSCalendarUnitMonth + NSCalendarUnitDay +
                  NSCalendarUnitHour + NSCalendarUnitMinute +
                  NSCalendarUnitSecond fromDate:date];
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger
      triggerWithDateMatchingComponents:triggerDate repeats:NO];

    NSString *identifier = [_selectedModelDict objectForKey:@"title"];
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier
                                                                          content:content trigger:trigger];

    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Something went wrong: %@",error);
        }
    }];

    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)updateMehodDic:(nonnull NSMutableDictionary *)updatedDict :(NSInteger)index :(NSInteger)indexSearch {
    _selectedModelDict = updatedDict;
    _nameLabel.text = [_selectedModelDict objectForKey:@"title"];
    _detailsLabel.text = [_selectedModelDict objectForKey:@"detail"];
    _piriorityLabel.text = [_selectedModelDict objectForKey:@"prio"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy hh:min a"];
    NSString *datePicker = [dateFormatter stringFromDate:[_selectedModelDict objectForKey:@"date"]];
    _dateLabel.text = datePicker;
}

//    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextView)];
//
//    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
//
//    [self.view addGestureRecognizer:rightSwipe];
//
//}
//-(void) nextView{
//
//    UpdateViewController *updateVC = [self.storyboard instantiateViewControllerWithIdentifier:@"updateVC"];
//    [updateVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//
//
//    [self presentViewController:updateVC animated:YES completion:^(void){
//
//
//        updateVC.editDict = self->_detailModelDict;
//        updateVC.index = _index;
//
//        updateVC.Update = self;
//
//    }];
//}
@end
