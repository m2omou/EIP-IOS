//
//  NBAnnotationView.m
//  neerbyy
//
//  Created by Maxime de Chalendar on 06/02/2014.
//  Copyright (c) 2014 neerbyy. All rights reserved.
//

#import "NBPlaceAnnotationView.h"
#import <CCHMapClusterAnnotation.h>
#import "NBTheme.h"
#import "NBPlaceAnnotation.h"


@interface NBPlaceAnnotationView ()

@property (strong, nonatomic) UIButton *calloutView;
@property (strong, nonatomic) void (^onCalloutTap)(MKAnnotationView *);

@end


@implementation NBPlaceAnnotationView

#pragma mark - Initialisation

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.highlighted = NO;
        [self initCalloutView];
    }
    
    return self;
}

- (void)initCalloutView
{
    NBTheme *theme = [NBTheme sharedTheme];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat height = 30.f;
    CGFloat width = 100.f;
    button.frame = CGRectMake((self.image.size.width - width) / 2.f,
                              -(self.image.size.height + height) / 2.f - 4.f,
                              width, height);
    
    button.layer.cornerRadius = 5.f;
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    [button setBackgroundColor:[theme.lightGreenColor colorWithAlphaComponent:0.9f]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:self.annotation.title.uppercaseString forState:UIControlStateNormal];
    [button addTarget:self action:@selector(tappedCallout:) forControlEvents:UIControlEventTouchUpInside];
    
    button.titleLabel.font = [theme.boldFont fontWithSize:10.f];

    self.calloutView = button;
}

#pragma mark - Public methods

- (void)showCalloutWithAction:(void (^)(MKAnnotationView *))onCalloutTap
{
    self.onCalloutTap = onCalloutTap;
    
    CCHMapClusterAnnotation *mapClusterAnnotation = self.annotation;
    NSString *title;
    if ([mapClusterAnnotation isCluster])
    {
        NSUInteger numberOfAnnotations = mapClusterAnnotation.annotations.count;
        title = [NSString stringWithFormat:@"%@ lieux...", @(numberOfAnnotations)];
    }
    else
    {
        NBPlaceAnnotation *placeAnnotation = mapClusterAnnotation.annotations.anyObject;
        title = placeAnnotation.title;
    }
    [self.calloutView setTitle:title.uppercaseString forState:UIControlStateNormal];

    [self addSubview:self.calloutView];
}

- (void)hideCallout
{
    [self.calloutView removeFromSuperview];
}

#pragma mark - Properties

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    UIImage *pinImage;
    if (highlighted)
        pinImage = [UIImage imageNamed:@"map-pin-selected"];
    else
        pinImage = [UIImage imageNamed:@"map-pin"];
    self.image = pinImage;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setHighlighted:selected];
}

#pragma mark - Clickable subviews (custom callout)

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if (hitView != nil)
        [self.superview bringSubviewToFront:self];

    return hitView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect rect = self.bounds;
    BOOL isInside = CGRectContainsPoint(rect, point);

    if (isInside == NO)
    {
        for (UIView *view in self.subviews)
        {
            isInside = CGRectContainsPoint(view.frame, point);
            if (isInside)
                break;
        }
    }
    return isInside;
}

- (void)tappedCallout:(UIButton *)callout
{
    if (self.onCalloutTap)
        self.onCalloutTap(self);
}

@end
