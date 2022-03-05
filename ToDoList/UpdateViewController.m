//
//  UpdateViewController.m
//  ToDoList
//
//  Created by Abdullah on 05/03/2022.
//  Copyright © 2022 Abdullah MAhmoud. All rights reserved.
//

#import "UpdateViewController.h"
#import "DataModel.h"

@interface UpdateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *updateNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *updateDescriptionTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *updatePirorityPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *updateDatePicker;

@end

@implementation UpdateViewController
{
    NSArray *prio;
    NSMutableDictionary *dict;
    NSDate *nowDate;
    NSDate * remaindDate;}

- (void)viewDidLoad {
    [super viewDidLoad];
    dict = [NSMutableDictionary new];
    nowDate = [NSDate new];
    remaindDate = [NSDate new];
//    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveUpdateBtnTapped)];
//
//    [self.navigationItem setRightBarButtonItem:saveBtn];

    prio = @[@"High",@"Medium",@"Low"];
    self.updatePirorityPicker.dataSource = self;
    self.updatePirorityPicker.delegate = self;

    _updateNameTextField.text = [_editDict objectForKey:@"title"];
    _updateDescriptionTextField.text = [_editDict objectForKey:@"detail"];

    int index = 0;
    int priorityy = 0;
    for (NSString* priority in prio) {
        if ([priority  isEqual: [_editDict objectForKey:@"prio"]]) {
            priorityy = index;
        }
        index ++;
    }
    [_updatePirorityPicker selectRow:priorityy inComponent:0 animated:TRUE];
    [_updateDatePicker setDate:[_editDict objectForKey:@"date"]];
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
    _prioTxt = prio[row];
}


- (IBAction)saveUpdateBtn:(id)sender {
    
    UIAlertController *saveAlert = [UIAlertController alertControllerWithTitle:@"Save" message:@"Do you Want To Save Changes" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * saveBtn = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DataModel *model =[DataModel new];
        model.name = self->_updateNameTextField.text;
        model.dataDescription = self->_updateDescriptionTextField.text;
        
        if (self->_prioTxt == nil) {
            model.priority = self->prio[0];
        }else {
            model.priority = self->_prioTxt;
        }
        
        model.remainderDate = self->_updateDatePicker.date;
        model.createdDate = self->nowDate;

        [self->dict setObject:model.name forKey:@"title"];
        [self->dict setObject:model.dataDescription forKey:@"detail"];
        [self->dict setObject:model.priority forKey:@"prio"];
        [self->dict setObject:model.createdDate forKey:@"dateCreated"];
        [self->dict setObject:model.remainderDate forKey:@"date"];
        [self->_Update updateMehodDic:self->dict :self->_index.row :self->_indexSearch];
        self.onDoneBlock(self->dict);
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction * dontSaveBtn = [UIAlertAction actionWithTitle:@"Don't Save" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [saveAlert addAction:saveBtn];
    [saveAlert addAction:dontSaveBtn];
    [saveAlert addAction:cancel];
    [self presentViewController:saveAlert animated:YES completion:nil];
    
 
//  [self.navigationController popViewControllerAnimated:YES];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:TRUE];
////    prio = @[@"High",@"Medium",@"Low"];
////    self.updatePirorityPicker.dataSource = self;
////    self.updatePirorityPicker.delegate = self;
////
////    _updateNameTextField.text = [_editDict objectForKey:@"title"];
////    _updateDescriptionTextField.text = [_editDict objectForKey:@"detail"];
////
////    int index = 0;
////    int priorityy = 0;
////    for (NSString* priority in prio) {
////        if ([priority  isEqual: [_editDict objectForKey:@"prio"]]) {
////            priorityy = index;
////        }
////        index ++;
////    }
////    [_updatePirorityPicker selectRow:priorityy inComponent:0 animated:TRUE];
////    [_updateDatePicker setDate:[_editDict objectForKey:@"date"]];
//}

@end
