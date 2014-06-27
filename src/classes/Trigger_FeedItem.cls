public without sharing class Trigger_FeedItem {
    /*
    Network pub;

    public Trigger_FeedItem() {
        pub = [SELECT id FROM Network WHERE Name LIKE '%Power of Us%' LIMIT 1];
    }

    /******************************************************************************
    * Restrict posts to specific Chatter Groups in the Power us Hub, designated by
    * a semi-colon delimited text field in Power of Us Hub custom settings.
    * Accepts trigger.new as an argument.
    *******************************************************************************/
    /*
    public void chatterPUBAutoTopicTagging(List<FeedItem> itemsFromTrigger) {

        Set<id> feedItemGroups = new Set<id>();
        Map<id,string> groupTopicMap;

        for (FeedItem item : itemsFromTrigger) {
            //make sure the trigger is only firing on feed items in a Community, to a group
            if (item.NetworkScope != 'AllNetworks' && item.NetworkScope == pub.id && ((string)(item.ParentId)).startsWith('0F9')) {
                feedItemGroups.add(item.ParentId);
            } 
        }

        //now see if we have any Categories associated with the groups containing these posts
        if (!feedItemGroups.isEmpty()) {
            List<Category__c> relevantCategories = [SELECT Chatter_Group_Id__c, Topics__c 
                                                    FROM Category__c 
                                                    WHERE Chatter_Group_Id__c 
                                                    IN :feedItemGroups];

            //now build the map of chatter group id to topics
            if (!relevantCategories.isEmpty()) {
    
                groupTopicMap = new Map<id,string>();
                Map<string,id> hubTopicMap = new Map<string,id>();

                //build a map of all Hub topics
                List<Topic> hubTopics = [SELECT Id, Name FROM Topic WHERE NetworkId = :pub.id];
                system.debug('HUB TOPICS FOUND: ' + hubTopics);
                for (Topic t : hubTopics) {
                    hubTopicMap.put(t.Name,t.Id);
                }

                for (Category__c c : relevantCategories) { 
                    groupTopicMap.put(c.Chatter_Group_Id__c,c.Topics__c);   
                }
                
                List<TopicAssignment> assignmentsToCreate = new List<TopicAssignment>();

                for (FeedItem item : itemsFromTrigger) {
                    string topicString = groupTopicMap.get(item.ParentId);
                    if (topicString != null) {
                        for (string s : topicString.split(';')) {
                            if (hubTopicMap.get(s) != null) {
                                TopicAssignment ta = new TopicAssignment(
                                    EntityId = item.id,
                                    NetworkId = pub.id,
                                    TopicId = hubTopicMap.get(s)
                                );
                                assignmentsToCreate.add(ta);
                            }
                        }
                    }
                }

                try {
                    if (!assignmentsToCreate.isEmpty()) insert assignmentsToCreate;
                } catch (Exception e) {
                    WLMA_Error_Logger.log( e, 'Trigger_FeedItem', 'chatterPUBAutoTopicTagging', userInfo.getUserId());
                }
            }
        }
    }

    public void attachQuestionTopic(List<FeedItem> itemsFromTrigger) {

        List<TopicAssignment> assignmentsToCreate = new List<TopicAssignment>();

        for (FeedItem item : itemsFromTrigger) {
            if (item.NetworkScope != 'AllNetworks' && item.NetworkScope == pub.id && item.Type == 'QuestionPost') {
                TopicAssignment questionTopic = new TopicAssignment(
                    EntityId = item.id,
                    NetworkId = pub.id,
                    TopicId = Settings.pubSettings.Question_Topic_Id__c
                );
                assignmentsToCreate.add(questionTopic);
            }
        }

        try {
            if (!assignmentsToCreate.isEmpty()) insert assignmentsToCreate;
        } catch (Exception e) {
            WLMA_Error_Logger.log( e, 'Trigger_FeedItem', 'attachQuestionTopic', userInfo.getUserId());
        }

    }
*/
}