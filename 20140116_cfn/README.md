AWS CloudFormation Hangout: January 16, 2014
========================================================
Thanks for joining AWS Developer Community Manager Evan Brown (@evandbrown on [GitHub](http://github.com/evandbrown) and [Twitter](http://twitter.com/evandbrown)) for the first Cloudformation Hangout of 2014. The Hangout starts at 9:00 AM PST on Thursday, January 16, and is scheduled for 30 minutes.

[Check out the index](../README.md) for a list of our previous Hangouts, including detailed agenda and recordings.

## The Recording
Apologies for the video issues! Fortunately audio is intact, and we think we've identified the problem to avoid in future events. Watch the recording of the live session - including Q&A - below:

[![](img/video.png)](https://plus.google.com/events/c2fl0tchd40roion9bdsr2g3c50)

## Agenda Overview
* New features since the last Hangout
* Feature Highlight: Using {{ mustache }} in your CloudFormation templates
* Focus on the Forums: Top posts and answers of the week
* Your Q&A

## About the Q&A
Q&A is enabled for this Hangout. To ask your question, click the Ask a new question button in the bottom-right corner of your screen, like so:

![](img/hangout-qa.png)

You can enter your questions at any point during the hangout. Keep in mind that it takes about 50 seconds before the audio and video to make it through all the tubes to your computer, so by the time you've typed your question we may be on another topic. But don't worry! We've got the final half of the Hangout reserved just for Q&A.

## New Features
Here's what's been added to CloudFormation in the last 4 weeks:

1. **CloudFormation** - Up to 60 parameters and 60 outputs per template
2. **Auto Scaling** - Create a group from a running instance; use provisioned IOPS volumes
3. **SQS** - Update queues and queue policies
4. **AWS Marketplace** - If you are looking for turnkey solutions, trials or want to sell your own, [AWS Marketplace](https://aws.amazon.com/marketplace) now supports products packaged as CloudFormation templates.

Check out the release notes at [http://aws.amazon.com/releasenotes/AWS-CloudFormation](http://aws.amazon.com/releasenotes/AWS-CloudFormation) for more information.

## Feature Highlight: {{ mustache }}
Did you know that CloudFormation supports [mustache](http://mustache.github.io/) templates? Let's use WordPress as an example to see that feature in action.

We can use CloudFormation to launch and bootstrap a WordPress environment with [this sample template](https://s3.amazonaws.com/cloudformation-templates-us-east-1/WordPress_Single_Instance_With_RDS.template). Looking more closely at the template, we see it's using [AWS::CloudFormation::Init](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-init.html) to install and configure WordPress on each instance. Specifically, on line 133 we see the template is creating the important `wp-config.php` file that contains Wordpress configuration information, including database hostname, username, and password:

```json
...
"files" : {
  "/var/www/html/wordpress/wp-config.php" : {
    "content" : { "Fn::Join" : ["", [
      "<?php\n",
      "define('DB_NAME',          '", {"Ref" : "DBName"}, "');\n",
      "define('DB_USER',          '", {"Ref" : "DBUsername"}, "');\n",
      "define('DB_PASSWORD',      '", {"Ref" : "DBPassword" }, "');\n",
      "define('DB_HOST',          '", {"Fn::GetAtt" : ["DBInstance", "Endpoint.Address"]},"');\n",
      "define('DB_CHARSET',       'utf8');\n",
      "define('DB_COLLATE',       '');\n"
    ]] },
    "mode" : "000644",
    "owner" : "root",
    "group" : "root"
  }
},
...
```

If you've used CloudFormation to bootstrap your instances before, you're probably familiar with using the intrinsic functions `Fn::Join` and `Ref` to build up a file like that. In this example, it looks a lot more like JSON than PHP.

Mustache support in CloudFormation makes it easy to templatize your files, store them in S3, and reference them from within a template without having to build them piecemeal. In the previous example, I templatize `wp-config.php` and store it in S3 as `wp-config.php.tpl`. The resulting template is available [here](wp-config.php.tpl) in this repo. Here's a snippet:

```php
<?php
define('DB_NAME',          '{{DBName}}');
define('DB_USER',          '{{DBUsername}}');
define('DB_PASSWORD',      '{{DBPassword}}');
define('DB_HOST',          'localhost');
define('DB_CHARSET',       'utf8');
define('DB_COLLATE',       '');
```

Within my CloudFormation template I still declare an entry for that file, but rather than building the content out using intrinsic functions I simply point to the mustache template in the `source` property and define the substitutions with the `context` object:

```json
"files" : { 
    "/var/www/html/wordpress/wp-config.php" : {
      "source" : "http://s3.amazonaws.com/evbrown/public/wp-config.php.tpl",
      "mode" : "000644",
      "owner" : "root",
      "group" : "root",
      "context" : {
        "DBUsername" : {"Ref" : "DBUsername"},
        "DBPassword" : {"Ref" : "DBPassword"},
        "DBName" : {"Ref" : "DBName"}
      }
    }
}
```

The complete CloudFormation template is available [here](wp_mustache.cfn.json) in this repo.

If you have complex files you build inside of CloudFormation JSON, consider how you might use this functionality to centralize these files in S3. In the next office hours we'll discuss how to restrict access to your template files.

## Focus on the Forums

### [Passing a CommaDelimitedList Param via CLI](https://forums.aws.amazon.com/thread.jspa?threadID=142854&tstart=0)
* Upgrade to latest version of the `aws` CLI (>=1.2.10)
* Params are now passed in a simpler "key1=value1;key2=value2" format
* Passing a CommaDelimistedList param example:

        aws cloudformation create-stack --stack-name demo \
            --template-body file://demo.json \
            --parameters ParameterKey=PublicSubnets,ParameterValue='subnet1\,subnet2\,subnet3'

---

### [ Create an SQS Queue for each Instance in an ASG](https://forums.aws.amazon.com/thread.jspa?threadID=143546&tstart=0#)
Two options:

1. Configure Auto Scaling to notify you when an Instance is added or removed. Handle that notification and use API to create or delete a queue. ( [Documentation](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-as-group.html#cfn-as-group-notificationconfiguration)):

    ```json
    ...
    "AutoScalingGroup" : {
      "Type" : "AWS::AutoScaling::AutoScalingGroup",
      "Properties" : {
        "AvailabilityZones" : { "Fn::GetAZs" : ""},
        "LaunchConfigurationName" : { "Ref" : "LaunchConfig" },
        "MinSize" : "1",
        "MaxSize" : "3",
        "LoadBalancerNames" : [ { "Ref" : "ElasticLoadBalancer" } ],
        "NotificationConfiguration" : {
          "TopicARN" : { "Ref" : "NotificationTopic" },
          "NotificationTypes" : [ "autoscaling:EC2_INSTANCE_LAUNCH","autoscaling:EC2_INSTANCE_LAUNCH_ERROR","autoscaling:EC2_INSTANCE_TERMINATE", "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"]
        }
     }
    }
    ...
    ```

2. Create an SQS Queue via SDK/CLI/API on each Instance via UserData (**caveat**: consider how you will delete this Queue when an Instance goes away):

    ```json
    ...
    "AutoScalingLaunchConfig": {  
      "Type": "AWS::AutoScaling::LaunchConfiguration",
      "Properties": {
        "ImageId" : "...",
        "InstanceType"   : { "Ref" : "InstanceType" },
        ...
        "UserData"       : { "Fn::Base64" : { "Fn::Join" : ["", [
          "#!/bin/bash -v\n",
          "aws sqs create-queue ..."
        ]]}}        
      }
    },
    ...
    ```

---

### [Reference Account ID in a Template/Stack](https://forums.aws.amazon.com/thread.jspa?threadID=101106&tstart=0#)

* The `AccountId` pseudo parameter was added several months ago: `{"Ref" : "AWS::AccountId"}`

---

### [CloudFormation Events to an SQS Queue via SNS](https://forums.aws.amazon.com/thread.jspa?threadID=143617&tstart=0)

When you launch a CloudFormation stack, you can provide an SNS Topic that CloudFormation will publish an event stream to. You may want those messages to flow into an SQS queue for offline processing by subscribing that Queue as an Endpoint to your Topic. In addition to the subscription, be sure to add a Queue Policy to your Queue granting SendMessage permissions to your topic. For more details, including an example Queue Policy, see [the documentation](http://docs.aws.amazon.com/sns/latest/dg/SendMessageToSQS.html)

---

### [Increase Size of C:\ on Stack Creation](https://forums.aws.amazon.com/thread.jspa?threadID=142940&tstart=0)
Use the `BlockDeviceMappings` property of the `AWS::EC2::Instance` or `AWS::AutoScaling::LaunchConfiguration` Resources to set the size.

```json
...
"Ec2Instance" : {
  "Type" : "AWS::EC2::Instance", 
  "Properties" : {
    "ImageId" : { "Ref" : "ImageId" },
    "InstanceType" : { "Ref" : "InstanceType" },
    "SecurityGroups" : [{ "Ref" : "Ec2SecurityGroup" }],
    "BlockDeviceMappings" : [
      {
        "DeviceName" : "/dev/sda1",
        "Ebs" : { "VolumeSize" : "50" } 
      },{
        "DeviceName" : "/dev/sdm",
        "Ebs" : { "VolumeSize" : "100" }
      }
    ]
  }
},
...
```

For a complete example, see [the documentation](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/quickref-ec2.html#scenario-ec2-bdm)

## Q&A