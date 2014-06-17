//
//  NBReportViewController.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 17/06/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBReportViewController.h"
#import "NBLabel.h"

@interface NBReportViewController ()

@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (strong, nonatomic) IBOutlet NBLabel *placeHolderLabel;

@end

@implementation NBReportViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self themeDescriptionTextView];
    __weak NBReportViewController *weakSelf = self;
    self.customValidation = ^BOOL{
        if (weakSelf.descriptionTextView.text.length == 0)
            return NO;
        return YES;
    };
}

#pragma mark - Theming

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

#pragma mark - Convinience methods

- (void)createComment
{
    NSString *description = self.descriptionTextView.text;
    NSNumber *identifierToReport = self.identifierToReport;
    
    [self createReportOperationWithIdentifier:identifierToReport description:description];
}

- (void)createReportOperationWithIdentifier:(NSNumber *)identifierToReport description:(NSString *)description
{
    Class requestClass = [NBAPIRequest class];
    NSAssert([requestClass respondsToSelector:self.operationCreator], @"Operation to report (%@) isn't on request class (%@)", NSStringFromSelector(self.operationCreator), requestClass);

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NBAPINetworkOperation *reportOperation = [requestClass performSelector:self.operationCreator withObject:identifierToReport withObject:description];
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
