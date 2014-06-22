//
//  NBReportViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import <objc/message.h>
#import "NBReportViewController.h"
#import "NBReport.h"
#import "NBLabel.h"

@interface NBReportViewController ()

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet NBLabel *placeHolderLabel;
@property (strong, nonatomic) IBOutlet NBPrimaryButton *reasonButton;
@property (strong, nonatomic) IBOutlet UIPickerView *reasonPicker;

@property (assign, nonatomic) NBReportType selectedType;

@end

@implementation NBReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self themeDescriptionTextView];
    [self themeReasonButton];
    __weak NBReportViewController *weakSelf = self;
    self.customValidation = ^BOOL{
        if (weakSelf.descriptionTextView.text.length == 0)
            return NO;
        return YES;
    };
}

#pragma mark - Theming

- (void)themeReasonButton
{
    NSString *typeTitle = self.reportReasons[self.selectedType];
    NSString *title = [NSString stringWithFormat:@"Raison : %@", typeTitle];
    [self.reasonButton setTitle:title forState:UIControlStateNormal];
}

- (void)themeDescriptionTextView
{
    UIColor *textColor = self.theme.lightGreenColor;
    
    self.placeHolderLabel.textColor = textColor;
    self.descriptionTextView.tintColor = textColor;
}

#pragma mark - User interactions

- (IBAction)tappedValidationButton:(id)sender
{
    [self validateForm];
}

- (IBAction)tappedCancelButton:(id)sender
{
    // TODO : Notify delegate
    [self dismiss];
}

- (IBAction)pressedReasonButton:(id)sender
{
    [self.descriptionTextView resignFirstResponder];
}

#pragma mark - NBGenericFormViewController

- (void)validateForm
{
    [super validateForm];
    [self disableValidationButton];
    [self createComment];
}

#pragma mark - UIBarPositioningDelegate

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView;
{
    BOOL hidePlaceHolder = (self.descriptionTextView.text.length > 0);
    self.placeHolderLabel.hidden = hidePlaceHolder;
    
    [self enableValidationButtonIfNeeded];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.reportReasons[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedType = row;
    [self themeReasonButton];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.f;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.reportReasons.count;
}

#pragma mark - Convinience methods

- (void)createComment
{
    NSString *description = self.descriptionTextView.text;
    NSNumber *identifierToReport = self.identifierToReport;
    NSNumber *reason = @(self.selectedType);
    
    [self createReportOperationWithIdentifier:identifierToReport description:description reason:reason];
}

- (void)createReportOperationWithIdentifier:(NSNumber *)identifierToReport description:(NSString *)description reason:(NSNumber *)reason
{
    Class requestClass = [NBAPIRequest class];
    NSAssert([requestClass respondsToSelector:self.operationCreator], @"Operation to report (%@) isn't on request class (%@)", NSStringFromSelector(self.operationCreator), requestClass);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NBAPINetworkOperation *reportOperation = objc_msgSend(requestClass, self.operationCreator, identifierToReport, description, reason);
;
#pragma clang diagnostic pop
    
    [reportOperation addCompletionHandler:^(NBAPINetworkOperation *operation) {
        // TODO : Notify delegate
        [self dismiss];
    } errorHandler:^(NBAPINetworkOperation *operation, NSError *error) {
        [NBAPINetworkOperation defaultErrorHandler](operation, error);
        [self enableValidationButtonIfNeeded];
    }];
    
    [reportOperation enqueue];
}

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
