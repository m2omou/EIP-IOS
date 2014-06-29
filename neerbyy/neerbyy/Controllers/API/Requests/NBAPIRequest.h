//
//  NBAPIRequest.h
//  neerbyy
//
//  Created by Maxime de Chalendar on 31/01/2014.
//  Copyright (c) 2014 Maxime de Chalendar. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "NBReport.h"
#import "NBVote.h"
#import "NBSettings.h"
@class NBAPINetworkOperation;


@interface NBAPIRequest : NSObject

+ (NBAPINetworkOperation *)registerWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email avatar:(UIImage *)avatar;

+ (NBAPINetworkOperation *)loginWithUsername:(NSString *)username password:(NSString *)password;
+ (NBAPINetworkOperation *)logout;

+ (NBAPINetworkOperation *)updateFirstName:(NSString *)firstName lastName:(NSString *)lastName username:(NSString *)username
                                     email:(NSString *)email password:(NSString *)password avatar:(UIImage *)avatar;
+ (NBAPINetworkOperation *)deleteAccount;

+ (NBAPINetworkOperation *)sendForgetPasswordWithEmail:(NSString *)email;

+ (NBAPINetworkOperation *)fetchCategories;
+ (NBAPINetworkOperation *)fetchPlacesAroundCoordinate:(CLLocationCoordinate2D)coordinate withCategory:(NSString *)categoryId;
+ (NBAPINetworkOperation *)fetchPlacesWithName:(NSString *)name;
+ (NBAPINetworkOperation *)fetchFollowedPlaces;
+ (NBAPINetworkOperation *)fetchFollowedPlacesSinceId:(NSNumber *)sinceId;
+ (NBAPINetworkOperation *)fetchFollowedPlacesAfterId:(NSNumber *)afterId;
+ (NBAPINetworkOperation *)followPlace:(NSString *)placeId;
+ (NBAPINetworkOperation *)unfollowPlace:(NSNumber *)followingId;

+ (NBAPINetworkOperation *)fetchPublicationsForPlace:(NSString *)placeIdentifier;
+ (NBAPINetworkOperation *)fetchPublicationsForPlace:(NSString *)placeIdentifier sinceId:(NSNumber *)sinceId;
+ (NBAPINetworkOperation *)fetchPublicationsForPlace:(NSString *)placeIdentifier afterId:(NSNumber *)afterId;
+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier withImage:(UIImage *)image description:(NSString *)description;
+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier withURL:(NSString *)url description:(NSString *)description;
+ (NBAPINetworkOperation *)createPublicationOnPlace:(NSString *)placeIdentifier withDescription:(NSString *)description;
+ (NBAPINetworkOperation *)deletePublication:(NSNumber *)publicationId;
+ (NBAPINetworkOperation *)reportPublication:(NSNumber *)publicationId withDescription:(NSString *)description forReason:(NSNumber *)reason;

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
+ (NBAPINetworkOperation *)reportComment:(NSNumber *)commentId withDescription:(NSString *)description forReason:(NSNumber *)reason;

+ (NBAPINetworkOperation *)fetchConversations;
+ (NBAPINetworkOperation *)fetchConversationsSinceId:(NSNumber *)sinceId;
+ (NBAPINetworkOperation *)fetchConversationsAfterId:(NSNumber *)afterId;
+ (NBAPINetworkOperation *)fetchMessagesForConversation:(NSNumber *)conversationId;
+ (NBAPINetworkOperation *)fetchMessagesForConversation:(NSNumber *)conversationId sinceId:(NSNumber *)sinceId;
+ (NBAPINetworkOperation *)fetchMessagesForConversation:(NSNumber *)conversationId afterId:(NSNumber *)afterId;
+ (NBAPINetworkOperation *)sendMessageToUser:(NSNumber *)userIdentifier withContent:(NSString *)content;

+ (NBAPINetworkOperation *)fetchUserWithUsername:(NSString *)username;

+ (NBAPINetworkOperation *)fetchSettings;
+ (NBAPINetworkOperation *)updateSettings:(NBSettings *)settings;

@end
