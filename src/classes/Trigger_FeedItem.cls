public without sharing class Trigger_FeedItem {
    
    public Trigger_FeedItem() {

    }

    /******************************************************************************
    * Add Topics to chatter posts based on what group they are in.
    * Accepts trigger.new as an argument.
    *******************************************************************************/
    
    public void chatterAutoTopicTagging(List<FeedItem> itemsFromTrigger) {

        Set<id> feedItemGroups = new Set<id>();

        Map<id,string> parentTopicMap;
        Map<id,string> parentGroupMap;

        for (FeedItem item : itemsFromTrigger) {
            feedItemGroups.add(item.ParentId);
        }

        //now see if we have any Categories associated with the groups containing these posts
        if (!feedItemGroups.isEmpty()) {
            List<Chatter_Category__c> relevantCategories = [SELECT Parent_Id__c, Topics__c, Chatter_Group_Id__c 
                                                    FROM Chatter_Category__c 
                                                    WHERE Parent_Id__c 
                                                    IN :feedItemGroups];

            //now build the map of chatter group id to topics
            if (!relevantCategories.isEmpty()) {
    
                parentTopicMap = new Map<id,string>();
                Map<string,id> existingTopicMap = new Map<string,id>();

                //build a map of all Hub topics
                List<Topic> topicQuery = [SELECT Id, Name FROM Topic];
                for (Topic t : topicQuery) {
                    existingTopicMap.put(t.Name,t.Id);
                }

                for (Chatter_Category__c c : relevantCategories) { 
                    parentTopicMap.put(c.Parent_Id__c,c.Topics__c);   
                }
                
                List<TopicAssignment> assignmentsToCreate = new List<TopicAssignment>();

                for (FeedItem item : itemsFromTrigger) {
                    string topicString = parentTopicMap.get(item.ParentId);
                    if (topicString != null) {
                        for (string s : topicString.split(';')) {
                            if (existingTopicMap.get(s) != null) {
                                TopicAssignment ta = new TopicAssignment(
                                    EntityId = item.id,
                                    TopicId = existingTopicMap.get(s)
                                );
                                assignmentsToCreate.add(ta);
                            }
                        }
                    }
                }

                try {
                    if (!assignmentsToCreate.isEmpty()) insert assignmentsToCreate;
                } catch (Exception e) {
                  
                }
            }
        }
    }
}