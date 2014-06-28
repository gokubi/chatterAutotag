trigger FeedItemTrigger on FeedItem (after insert) {
   
   Trigger_FeedItem fi = new Trigger_FeedItem();

    if (trigger.isAfter) {
        fi.chatterAutoTopicTagging(trigger.new);
    } 
}