//
//  AddViewController.m
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import "AddViewController.h"
#import "EditViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController
{

    NSArray *prio;
    NSMutableDictionary *dict;
    NSDate *nowDate;
    NSDate * remaindDate;
}


- (IBAction)dateSelected:(id)sender {
  
  NSDate *selectedDate = [_datePicker date];
  NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
  [dateFormat setDateFormat:@"dd-MMM-yyyy hh:mm a"];
  _datePicked = [dateFormat stringFromDate:selectedDate];
  
}


- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
    nowDate = [NSDate new];
    remaindDate = [NSDate new];
    dict = [NSMutableDictionary new];

  UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveBtnTapped)];
  
  [self.navigationItem setRightBarButtonItem:saveBtn];
  
  prio = @[@"High",@"Medium",@"Low"];
  self.priorityPicker.dataSource = self;
  self.priorityPicker.delegate = self;
  
  
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return prio.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  return prio[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  _priorityTxt = prio[row];
}

- (void)saveBtnTapped {
//   DataModel *model =[DataModel new];
//  model.name = _nameTextField.text;
//  model.dataDescription = _descriptionTextField.text;
//  if (_priorityTxt == nil) {
//      model.priority = prio[0];
//  }else {
//      model.priority = _priorityTxt;
//  }
//
//    model.date = nowDate;
//
//
//  [dict setObject:model.name forKey:@"title"];
//  [dict setObject:model.dataDescription forKey:@"detail"];
//  [dict setObject:model.priority forKey:@"prio"];
//  [dict setObject:model.date forKey:@"date"];
//
////    [_P saveMethod:model];
//    [_Add saveMethodDict:dict];


  
    UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"Save" message:@"Do you Want To Save Changes" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * saveBtn = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DataModel *model =[DataModel new];
        model.name = self->_nameTextField.text;
        model.dataDescription = self->_descriptionTextField.text;
        if (self->_priorityTxt == nil) {
            model.priority = self->prio[0];
       }else {
           model.priority = self->_priorityTxt;
       }
       
        model.remainderDate = self->_datePicker.date;
        model.createdDate = self->nowDate;
        
        [self->dict setObject:model.name forKey:@"title"];
        [self->dict setObject:model.dataDescription forKey:@"detail"];
        [self->dict setObject:model.priority forKey:@"prio"];
        [self->dict setObject:model.createdDate forKey:@"dateCreated"];
        [self->dict setObject:model.remainderDate forKey:@"date"];

     //    [_P saveMethod:model];
        [self->_Add saveMethodDict:self->dict];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction * dontSaveBtn = [UIAlertAction actionWithTitle:@"Don't Save" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [saveAlert addAction:saveBtn];
    [saveAlert addAction:dontSaveBtn];
    [saveAlert addAction:cancel];
    [self presentViewController:saveAlert animated:YES completion:nil];
    //    [def setObject:_nameTextField.text forKey:@"Title"];
  //    [def setObject:_detailTextField.text forKey:@"detail"];
  //    [def setObject:_prioTxt forKey:@"prio"];
  //    [def setObject:_datePicked forKey:@"date"];
  //    [def synchronize];
  
  [self.navigationController popViewControllerAnimated:YES];
}


@end
