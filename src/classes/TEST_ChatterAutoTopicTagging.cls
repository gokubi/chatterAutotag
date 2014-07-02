@IsTest(SeeAllData=true)
public class TEST_ChatterAutoTopicTagging {
    
    static testMethod void singleTopic() {

        // Get some admin User in the foundation org
        User admin = [SELECT Id, Name FROM User WHERE Profile.name = 'System Administrator' and isActive = true LIMIT 1];

        // Get some random User in the foundation org
        User u = [SELECT Id, Name FROM User WHERE Profile.name = 'System Administrator' and isActive = true LIMIT 1];

        delete [SELECT Id from Chatter_Category__c];

        //Create a Chatter Group
        CollaborationGroup chatterGroup = new CollaborationGroup(
            Name = 'Navel Gazing',
            OwnerId = admin.id,
            CollaborationType = 'Public',
            CanHaveGuests = false
            );
        insert chatterGroup;

        Chatter_Category__c category = new Chatter_Category__c(
            Name = 'Junk',
            Parent_Id__c = chatterGroup.id,
            Topics__c = 'Navel Gazing;Mission and Vision'
            );
        insert category;

        Topic hubTopic = new Topic(
            Name = 'Navel Gazing'
            );
        insert hubTopic;

        FeedItem post;
        system.runAs(u) {
            post = new FeedItem(
                ParentId = chatterGroup.id,
                Type = 'TextPost',
                Body = 'I think I have a lint problem'
                );

            Test.StartTest();

            // on insert we should get a FeedItem with hashtags appended
            insert post;
        }

        List<TopicAssignment> assignedTopics = [SELECT id, Topic.Name FROM TopicAssignment 
                                                WHERE EntityId = :post.id
                                                AND TopicId = :hubTopic.id];
        system.assertEquals(1,assignedTopics.size());
        system.assert(assignedTopics[0].Topic.Name == 'Navel Gazing',assignedTopics[0].Topic.Name);

        Test.StopTest();

    }

    static testMethod void bulkInsert() {

        // Get some admin User in the foundation org
        User admin = [SELECT Id, Name FROM User WHERE Profile.name = 'System Administrator' and isActive = true LIMIT 1];

        // Get some random User in the foundation org
        User u = [SELECT Id, Name FROM User WHERE Profile.name = 'System Administrator' and isActive = true LIMIT 1];

        delete [SELECT Id from Chatter_Category__c];

        //Create a Chatter Group
        CollaborationGroup chatterGroup = new CollaborationGroup(
            Name = 'Navel Gazing',
            OwnerId = admin.id,
            CollaborationType = 'Public',
            CanHaveGuests = false
            );
        insert chatterGroup;

        //Create a Chatter Group
        CollaborationGroup chatterGroup2 = new CollaborationGroup(
            Name = 'Day Dreaming',
            OwnerId = admin.id,
            CollaborationType = 'Public',
            CanHaveGuests = false
            );
        insert chatterGroup2;

        Chatter_Category__c category = new Chatter_Category__c(
            Name = 'Junk',
            Parent_Id__c = chatterGroup.id,
            Topics__c = 'Navel Gazing;Mission and Vision'
            );
        insert category;

        Chatter_Category__c anotherCategory = new Chatter_Category__c(
            Name = 'Junk',
            Parent_Id__c = chatterGroup2.id,
            Topics__c = 'Day Dreaming;Mission and Vision'
            );
        insert anotherCategory;

        Topic hubTopic1 = new Topic(
            Name = 'Navel Gazing'
            );
        insert hubTopic1;

        Topic hubTopic2 = new Topic(
            Name = 'Day Dreaming'
            );
        insert hubTopic2;

        FeedItem post;
        FeedItem post2;
        system.runAs(u) {
            post = new FeedItem(
                ParentId = chatterGroup.id,
                Type = 'TextPost',
                Body = 'I think I have a lint problem'
                );

            post2 = new FeedItem(
                ParentId = chatterGroup2.id,
                Type = 'TextPost',
                Body = 'I can see my belly button'
                );

            List<FeedItem> posts = new List<FeedItem>();
            posts.add(post);
            posts.add(post2);

            Test.StartTest();

            // on insert we should get a FeedItem with hashtags appended
            insert posts;
        }

        List<TopicAssignment> assignedTopics = [SELECT id, Topic.Name FROM TopicAssignment 
                                                WHERE EntityId = :post.id
                                                AND TopicId = :hubTopic1.id];
        system.assertEquals(1,assignedTopics.size());
        system.assert(assignedTopics[0].Topic.Name == 'Navel Gazing',assignedTopics[0].Topic.Name);

        List<TopicAssignment> assignedTopics2 = [SELECT id, Topic.Name FROM TopicAssignment 
                                                WHERE EntityId = :post2.id
                                                AND TopicId = :hubTopic2.id];
        system.assertEquals(1,assignedTopics2.size());
        system.assert(assignedTopics2[0].Topic.Name == 'Day Dreaming',assignedTopics2[0].Topic.Name);

        Test.StopTest();

    }

    static testMethod void noTopicsFound() {
        
         // Get some admin User in the foundation org
        User admin = [SELECT Id, Name FROM User WHERE Profile.name = 'System Administrator' and isActive = true LIMIT 1];

        // Get some random User in the foundation org
        User u = [SELECT Id, Name FROM User WHERE Profile.name = 'System Administrator' and isActive = true LIMIT 1];

        delete [SELECT Id from Chatter_Category__c];

        //Create a Chatter Group
        CollaborationGroup chatterGroup = new CollaborationGroup(
            Name = 'Navel Gazing',
            OwnerId = admin.id,
            CollaborationType = 'Public',
            CanHaveGuests = false
            );
        insert chatterGroup;

        Chatter_Category__c category = new Chatter_Category__c(
            //make sure we don't ahve any categories with linked Chatter Groups
            Name = 'Junk',
            Parent_Id__c = null,
            Topics__c = 'Navel Gazing;Mission and Vision'
            );
        insert category;

        FeedItem post;
        system.runAs(u) {
            post = new FeedItem(
                ParentId = chatterGroup.id,
                Type = 'TextPost',
                Body = 'I think I have a lint problem'
                );

            Test.StartTest();

            // on insert we should get a FeedItem with hashtags appended
            insert post;
        }

        List<FeedItem> items = [SELECT body FROM FeedItem WHERE id = :post.id];
        system.assert(items[0].body.containsOnly('I think I have a lint problem'));
        system.debug('POST BODY: ' + items[0].body);

        Test.StopTest();
    }

    static testMethod void postToAccount() {
        // Get some admin User in the foundation org
        User admin = [SELECT Id, Name FROM User WHERE Profile.name = 'System Administrator' and isActive = true LIMIT 1];

        // Get some random User in the foundation org
        User u = [SELECT Id, Name FROM User WHERE Profile.name = 'System Administrator' and isActive = true LIMIT 1];

        delete [SELECT Id from Chatter_Category__c];

        //Create a Chatter Group
        CollaborationGroup chatterGroup = new CollaborationGroup(
            Name = 'Account Stuff',
            OwnerId = admin.id,
            CollaborationType = 'Public',
            CanHaveGuests = false
            );
        insert chatterGroup;

        Chatter_Category__c category = new Chatter_Category__c(
            Name = 'Account posts',
            Parent_Id__c = '001',
            Topics__c = 'Navel Gazing;Mission and Vision',
            Chatter_Group_Id__c = chatterGroup.Id
            );
        insert category;
        
        Topic hubTopic = new Topic(
            Name = 'Navel Gazing'
            );
        insert hubTopic;

        Account account = new Account(
            Name='Junk account'
            );
        insert account;

        FeedItem post;
        system.runAs(u) {
            post = new FeedItem(
                ParentId = account.id,
                Type = 'TextPost',
                Body = 'I think I have a lint problem'
                );

            Test.StartTest();

            // on insert we should get a FeedItem with hashtags appended
            insert post;
        }
        //get feedpost and look for comment
        FeedItem createdFeedItem = [SELECT CommentCount FROM FeedItem WHERE Id = :post.id];

        system.assertEquals(1,createdFeedItem.CommentCount);

        List<TopicAssignment> assignedTopics = [SELECT id, Topic.Name FROM TopicAssignment 
                                                WHERE EntityId = :post.id
                                                AND TopicId = :hubTopic.id];
        system.assertEquals(1,assignedTopics.size());
        system.assert(assignedTopics[0].Topic.Name == 'Navel Gazing',assignedTopics[0].Topic.Name);

        Test.StopTest();
    }
}