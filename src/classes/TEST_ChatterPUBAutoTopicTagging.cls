@isTest
public class TEST_ChatterPUBAutoTopicTagging {
    /*
    static testMethod void singleTopic() {
        
        Network pub = [SELECT id FROM Network WHERE Name LIKE '%Power of Us%' LIMIT 1];

        // Get some admin User in the foundation org
        User admin = [SELECT Id, Name FROM User WHERE Profile.name = 'System Administrator' and isActive = true LIMIT 1];

        // Get some random User in the foundation org
        User u = [SELECT Id, Name FROM User WHERE Profile.Id = : Settings.pubSettings.Default_Customer_User_Profile_ID__c and isActive = true LIMIT 1];

        //Create a Chatter Group
        CollaborationGroup chatterGroup = new CollaborationGroup(
            Name = 'Navel Gazing',
            OwnerId = admin.id,
            CollaborationType = 'Public',
            NetworkId = pub.id,
            CanHaveGuests = false
            );
        insert chatterGroup;

        CollaborationGroupMember member = new CollaborationGroupMember(
            CollaborationGroupId = chatterGroup.id,
            MemberId = u.id,
            CollaborationRole = 'Standard'
            );
        insert member;

        Category__c category = new Category__c(
            Name = 'Navel Gazing',
            Chatter_Group_Id__c = chatterGroup.id,
            Topics__c = 'Navel Gazing;Mission and Vision'
            );
        insert category;

        Topic hubTopic = new Topic(
            Name = 'Navel Gazing',
            NetworkId = pub.id
            );
        insert hubTopic;

        FeedItem post;
        system.runAs(u) {
            post = new FeedItem(
                ParentId = chatterGroup.id,
                Type = 'TextPost',
                NetworkScope = pub.id,
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

        Network pub = [SELECT id FROM Network WHERE Name LIKE '%Power of Us%' LIMIT 1];
        
        // Get some admin User in the foundation org
        User admin = [SELECT Id, Name FROM User WHERE Profile.name = 'System Administrator' and isActive = true LIMIT 1];

        // Get some random User in the foundation org
        User u = [SELECT Id, Name FROM User WHERE Profile.Id = : Settings.pubSettings.Default_Customer_User_Profile_ID__c and isActive = true LIMIT 1];

        //Create a Chatter Group
        CollaborationGroup chatterGroup = new CollaborationGroup(
            Name = 'Navel Gazing',
            OwnerId = admin.id,
            NetworkId = pub.id,
            CollaborationType = 'Public',
            CanHaveGuests = false
            );
        insert chatterGroup;

        //Create a Chatter Group
        CollaborationGroup chatterGroup2 = new CollaborationGroup(
            Name = 'Day Dreaming',
            OwnerId = admin.id,
            NetworkId = pub.id,
            CollaborationType = 'Public',
            CanHaveGuests = false
            );
        insert chatterGroup2;

        CollaborationGroupMember member = new CollaborationGroupMember(
            CollaborationGroupId = chatterGroup.id,
            MemberId = u.id,
            CollaborationRole = 'Standard'
            );
        insert member;

        CollaborationGroupMember member2 = new CollaborationGroupMember(
            CollaborationGroupId = chatterGroup2.id,
            MemberId = u.id,
            CollaborationRole = 'Standard'
            );
        insert member2;

        Category__c category = new Category__c(
            Name = 'Navel Gazing',
            Chatter_Group_Id__c = chatterGroup.id,
            Topics__c = 'Navel Gazing;Mission and Vision'
            );
        insert category;

        Category__c anotherCategory = new Category__c(
            Name = 'Day Dreaming',
            Chatter_Group_Id__c = chatterGroup2.id,
            Topics__c = 'Day Dreaming;Mission and Vision'
            );
        insert anotherCategory;

        Topic hubTopic1 = new Topic(
            Name = 'Navel Gazing',
            NetworkId = pub.id
            );
        insert hubTopic1;

        Topic hubTopic2 = new Topic(
            Name = 'Day Dreaming',
            NetworkId = pub.id
            );
        insert hubTopic2;

        FeedItem post;
        FeedItem post2;
        system.runAs(u) {
            post = new FeedItem(
                ParentId = chatterGroup.id,
                Type = 'TextPost',
                NetworkScope = pub.id,
                Body = 'I think I have a lint problem'
                );

            post2 = new FeedItem(
                ParentId = chatterGroup2.id,
                Type = 'TextPost',
                NetworkScope = pub.id,
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
        
        Network pub = [SELECT id FROM Network WHERE Name LIKE '%Power of Us%' LIMIT 1];

        // Get some admin User in the foundation org
        User admin = [SELECT Id, Name FROM User WHERE Profile.name = 'System Administrator' and isActive = true LIMIT 1];

        // Get some random User in the foundation org
        User u = [SELECT Id, Name FROM User WHERE Profile.Id = : Settings.pubSettings.Default_Customer_User_Profile_ID__c and isActive = true LIMIT 1];

        //Create a Chatter Group
        CollaborationGroup chatterGroup = new CollaborationGroup(
            Name = 'Navel Gazing',
            OwnerId = admin.id,
            NetworkId = pub.id,
            CollaborationType = 'Public',
            CanHaveGuests = false
            );
        insert chatterGroup;

        CollaborationGroupMember member = new CollaborationGroupMember(
            CollaborationGroupId = chatterGroup.id,
            MemberId = u.id,
            CollaborationRole = 'Standard'
            );
        insert member;

        Category__c category = new Category__c(
            Name = 'Navel Gazing',
            //make sure we don't ahve any categories with linked Chatter Groups
            Chatter_Group_Id__c = null,
            Topics__c = 'Navel Gazing;Mission and Vision'
            );
        insert category;

        FeedItem post;
        system.runAs(u) {
            post = new FeedItem(
                ParentId = chatterGroup.id,
                Type = 'TextPost',
                NetworkScope = pub.id,
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

    static testMethod void questionPost() {
        
        Network pub = [SELECT id FROM Network WHERE Name LIKE '%Power of Us%' LIMIT 1];

        // Get some admin User in the foundation org
        User admin = [SELECT Id, Name FROM User WHERE Profile.name = 'System Administrator' and isActive = true LIMIT 1];

        // Get some random User in the foundation org
        User u = [SELECT Id, Name FROM User WHERE Profile.Id = : Settings.pubSettings.Default_Customer_User_Profile_ID__c and isActive = true LIMIT 1];

        //Create a Chatter Group
        CollaborationGroup chatterGroup = new CollaborationGroup(
            Name = 'Navel Gazing',
            OwnerId = admin.id,
            CollaborationType = 'Public',
            NetworkId = pub.id,
            CanHaveGuests = false
            );
        insert chatterGroup;

        CollaborationGroupMember member = new CollaborationGroupMember(
            CollaborationGroupId = chatterGroup.id,
            MemberId = u.id,
            CollaborationRole = 'Standard'
            );
        insert member;

        FeedItem post;
        system.runAs(u) {
            post = new FeedItem(
                ParentId = chatterGroup.id,
                Type = 'QuestionPost',
                NetworkScope = pub.id,
                Title = 'What is the meaning of life?',
                Body = 'I think I have a lint problem'
            );

            Test.StartTest();

            // on insert we should get a FeedItem with a topic appended 
            insert post;
        }

        List<TopicAssignment> topics = [SELECT EntityId, Id, IsDeleted, NetworkId, TopicId FROM TopicAssignment WHERE EntityId = :post.id];
        system.assertEquals(Settings.pubSettings.Question_Topic_Id__c,topics[0].TopicId);

        Test.StopTest();

    }
*/
}