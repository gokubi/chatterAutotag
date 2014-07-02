public without sharing class Trigger_FeedItem {
    
    public Trigger_FeedItem() {

    }

    /******************************************************************************
    * Add Topics to chatter posts based on what group they are in.
    * Accepts trigger.new as an argument.
    *******************************************************************************/
    
    public void chatterAutoTopicTagging(List<FeedItem> itemsFromTrigger) {

        //name for group that you want to @mention
        String groupName = 'Competitive Analysis';
        //map for the topics for a certain parent id
        Map<string,string> parentTopicMap = new Map<string,string>();
        //map for grooup id for a certain object prefix
        Map<string,id> parentTypeGroupMap = new Map<string,id>();

        List<Chatter_Category__c> allCategories = [SELECT Parent_Id__c, Topics__c, Chatter_Group_Id__c 
                                                FROM Chatter_Category__c
                                                WHERE Parent_Id__c <> null];

        Set<id> chatterGroupIds = new Set<id>();

        //create a set of group ids for getting group names, since the group field on Chatter_Category__c is a string field, not a lookup
        for (Chatter_Category__c thisCat : allCategories){
            if (thisCat.Chatter_Group_Id__c!=null){
                chatterGroupIds.add(thisCat.Chatter_Group_Id__c);
            }
         
        }
        //all relevant chatter groups
        Map<ID, CollaborationGroup> allChatterGroups = new Map<ID, CollaborationGroup>([SELECT id, Name FROM CollaborationGroup WHERE ID IN :chatterGroupIds]);

        if (!allCategories.isEmpty()) {  
            
            Map<string,id> existingTopicMap = new Map<string,id>();

            //build a map of all Hub topics
            List<Topic> topicQuery = [SELECT Id, Name FROM Topic];
            for (Topic t : topicQuery) {
                existingTopicMap.put(t.Name,t.Id);
            }

            for (Chatter_Category__c c : allCategories) {                 
                parentTopicMap.put(c.Parent_Id__c,c.Topics__c);  
                if(c.Parent_Id__c.left(3)!='0F9'){
                    parentTypeGroupMap.put(c.Parent_Id__c,c.Chatter_Group_Id__c);
                }
            }
            
            List<TopicAssignment> assignmentsToCreate = new List<TopicAssignment>();

            for (FeedItem item : itemsFromTrigger) {
                string topicString;
                if(((string)(item.ParentId)).left(3)=='0F9'){
                    topicString = parentTopicMap.get(item.ParentId);
                } else {
                    topicString = parentTopicMap.get(((string)(item.ParentId)).left(3)); 
                }
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
                Id chatterGroupId = parentTypeGroupMap.get(((string)(item.ParentId)).left(3));
                //only comment when it's not a group post and there isn't the correct @mention already
                if(((string)(item.ParentId)).left(3)!='0F9' && ((string)(item.ParentId)).left(3)!=null && !item.Body.contains('@' + allChatterGroups.get(chatterGroupId).Name) && chatterGroupId!=null){
                    ConnectApi.CommentInput commentInput = new ConnectApi.CommentInput();
                    ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                    ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
                    ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();

                    messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

                    mentionSegmentInput.id = chatterGroupId;
                    messageBodyInput.messageSegments.add(mentionSegmentInput);

                    commentInput.body = messageBodyInput;

                    ConnectApi.Comment commentRep = ConnectApi.ChatterFeeds.postComment(null, item.id, commentInput, null);
                }
            }

            try {
                if (!assignmentsToCreate.isEmpty()) insert assignmentsToCreate;
            } catch (Exception e) {
              
            }   
        }
    }
}