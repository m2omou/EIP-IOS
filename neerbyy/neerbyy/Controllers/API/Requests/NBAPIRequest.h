//
//  NBAPIRequest.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "NBVote.h"
@class NBAPINetworkOperation;


@interface NBAPIRequest : NSObject

+ (NBAPINetworkOperation *)registerWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email avatar:(UIImage *)avatar;

+ (NBAPINetworkOperation *)loginWithUsername:(NSString *)username password:(NSString *)password;
+ (NBAPINetworkOperation *)logout;

+ (NBAPINetworkOperation *)sendForgetPasswordWithEmail:(NSString *)email;

+ (NBAPINetworkOperation *)fetchPlacesAroundCoordinate:(CLLocationCoordinate2D)coordinate;
+ (NBAPINetworkOperation *)fetchFollowedPlaces;
+ (NBAPINetworkOperation *)fetchFollowedPlacesSinceId:(NSNumber *)sinceId;
+ (NBAPINetworkOperation *)fetchFollowedPlacesAfterId:(NSNumber *)afterId;
+ (NBAPINetworkOperation *)followPlace:(NSNumber *)placeId;
+ (NBAPINetworkOperation *)unfollowPlace:(NSNumber *)placeId;


+ (NBAPINetworkOperation *)fetchPublicationsForPlace:(NSString *)placeIdentifier;
+ (NBAPINetworkOperation *)fetchPublicationsForPlace:(NSString *)placeIdentifier sinceId:(NSNumber *)sinceId;
+ (NBAPINetworkOperation *)fetchPublicationsForPlace:(NSString *)placeIdentifier afterId:(NSNumber *)afterId;
+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier atPosition:(CLLocationCoordinate2D)position
                                          withImage:(UIImage *)image description:(NSString *)description;
+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier atPosition:(CLLocationCoordinate2D)position
                                            withURL:(NSString *)url description:(NSString *)description;
+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier atPosition:(CLLocationCoordinate2D)position
                                    withDescription:(NSString *)description;
+ (NBAPINetworkOperation *)deletePublication:(NSNumber *)publicationId;
+ (NBAPINetworkOperation *)reportPublication:(NSNumber *)publicationId;

+ (NBAPINetworkOperation *)fetchFlow;
+ (NBAPINetworkOperation *)fetchFlowSinceId:(NSNumber *)sinceId;
+ (NBAPINetworkOperation *)fetchFlowAfterId:(NSNumber *)afterId;

+ (NBAPINetworkOperation *)voteOnPublication:(NSNumber *)publicationId withValue:(NBVoteValue)value;
+ (NBAPINetworkOperation *)cancelVote:(NSNumber *)voteId;

+ (NBAPINetworkOperation *)fetchCommentsForPublication:(NSNumber *)publicationId;
+ (NBAPINetworkOperation *)fetchCommentsForPublication:(NSNumber *)publicationId sinceId:(NSNumber *)sinceId;
+ (NBAPINetworkOperation *)fetchCommentsForPublication:(NSNumber *)publicationId afterId:(NSNumber *)afterId;
+ (NBAPINetworkOperation *)commentOnPublication:(NSNumber *)publicationId withMessage:(NSString *)message;
+ (NBAPINetworkOperation *)removeComment:(NSNumber *)commentId;
+ (NBAPINetworkOperation *)reportComment:(NSNumber *)commentId;

@end
