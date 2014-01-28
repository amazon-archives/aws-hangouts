AWS CloudFormation Office Hours: January 30, 2014
========================================================
Thanks for joining AWS Developer Community Manager Evan Brown for CloudFormation Office Hours. The Hangout starts at 9:00 AM PST on Thursday, January 30, and is scheduled for 30 minutes.

This week we're joined by [Adam Thomas](http://www.linkedin.com/pub/adam-thomas/12/215/621/), a Software Deverlopment Engineer at AWS. You'll learn from Adam how to securely download content from S3 onto your EC2 Instances when using `cfn-init`, and he'll hang around to help answer questions.

[Check out the index](../README.md) for a list of our previous Hangouts, including detailed agenda and recordings.

## Agenda Overview
* New features since the last Hangout
* Community agenda items
* Feature Highlight: Adam Thomas covers using AWS::CloudFormation::Authentication for secure file and sources downloda with `cfn-init`
* Focus on the Forums: Top posts and answers of the week
* Your Q&A

## About the Q&A
Q&A is enabled for this Hangout. To ask your question, click the Ask a new question button in the bottom-right corner of your screen, like so:

![](img/hangout-qa.png)

You can enter your questions at any point during the hangout. Keep in mind that it takes about 50 seconds before the audio and video to make it through all the tubes to your computer, so by the time you've typed your question we may be on another topic. But don't worry! We've got the final half of the Hangout reserved just for Q&A.

## New Features
On January 27 CloudFormation added 2 new features:

1. **Auto Scaling scheduled actions support**: You can scale the number of Amazon EC2 instances in an Auto Scaling group based on a schedule. By using a schedule, you can scale applications in response to predictable load changes. For more information, see [AWS::AutoScaling::ScheduledAction](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-as-scheduledaction.html).

2. **Amazon DynamoDB secondary indexes**: You can create local and global secondary indexes for DynamoDB databases. By using secondary indexes, you can efficiently access data with attributes other than the primary key. For more information, see [AWS::DynamoDB::Table](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-dynamodb-table.html).

You can always find the latest release notes at [http://aws.amazon.com/releasenotes/AWS-CloudFormation](http://aws.amazon.com/releasenotes/AWS-CloudFormation)

## Community Agenda Suggestions

Kudos to the [alanwill](https://github.com/alanwill), [anthroprose](https://github.com/anthroprose), and [ringods](https://github.com/ringods) who forked the repo, added in some really great suggestions and sent Pull Requests! Let's look at their suggestions:

* Non-disruptive application upgrade: how to go from v1 to v2 of your app without downtime? Is it possible to deploy v2 of your app on new instances and flip the DNS all using CloudFormation?

    > Short answer is yes: if you manage DNS in Route 53 and CloudFormation with [AWS::Route53::RecordSet](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-route53-recordset.html), you can modify your CloudFormation template to resolve a record to - for example - a new ELB where v2 of your app has been deployed. If you're using [Weighted Record Sets](http://docs.aws.amazon.com/Route53/latest/DeveloperGuide/WeightedResourceRecordSets.html), you can introduce a new version of your application incrementally by adjusting the weight (i.e., distribution) of your Route 53 records in CloudFormation and update the stack periodically.
    >
    > Also consider that AWS Elastic Beanstalk provides an API to facilitate CNAME swap. See [Zero Downtime Deployment](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/using-features.CNAMESwap.html) for more information.

* How would I make a scalable way of passing Subnet information from one template to another for use with ELBs? ELB Subnets require "Type: A list of strings" however Template Paremeters can be String, Number, or CSV. Some of my regions have 3 AZs, some have 4. Passing subnets with a CSV such as: "ELBSubnets" : { "Fn::Join" : [",", [{ "Ref" : "PublicSubnet0" }, { "Ref" : "PublicSubnet1" }, { "Ref" : "PublicSubnet2" }]]} does not work. For now I need 1 template for 3 subnet ELBs and 1 template for 4 subnet ELBs.

    > CloudFormation supports a few different [input Parameter types](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/concept-parameters.html), including String and CommaDelimitedList. If you wanted to pass in a set of VPC Subnet IDs, you could use the CommaDelimitedList and Ref it from the ElasticLoadBalance resource:
    
    ```json
    {
      "Parameters": {
        "Subnets": {
          "Type": "CommaDelimitedList"
        }
      },
      "Resources": {
        "ElasticLoadBalancer": {
          "Type": "AWS::ElasticLoadBalancing::LoadBalancer",
          "Properties": {
            "Subnets": {
              "Ref": "Subnets"
            },
            "Listeners": [{
              "LoadBalancerPort": "80",
              "InstancePort": "80",
              "Protocol": "HTTP"
            }]
          }
        }
      }
    }
    ```

* Scalable Subnet Patterns & Best Practices for Multiple Regions & Environments (Production/Staging)

    > This is a good idea to dedicate more time to. We'll cover this in a Feature Focus segment of an upcoming Office Hours soon.

* Security groups that reference themselves. When you have a cluster using the same security group and each node in the cluster needs to communicate with other nodes in the cluster there's a need to create a Security Group rule with ports where the source is the same security group ID. How do you do this with CloudFormation?

    > By default, EC2 Instances in the same SG are not allowed to communicate with eachother. You need to add a self-referencing rule in the Security Group the Instances are running in. Because you can't Ref a Security Group resource in CloudFormation (because the resource doens't exist yet), the [AWS::EC2::SecurityGroupIngress](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-security-group-ingress.html) resource type exists to allow you to append ingress rules after resource creation. In this example we declare the `SGBase` resource, and Ref it from the `SGBaseIngress`:
    
    ```json
    {
        "AWSTemplateFormatVersion": "2010-09-09",
        "Resources": {
            "SGBase": {
                "Type": "AWS::EC2::SecurityGroup",
                "Properties": {
                    "GroupDescription": "Base Security Group",
                    "SecurityGroupIngress": [
                        {
                            "IpProtocol": "tcp",
                            "CidrIp": "0.0.0.0/0",
                            "FromPort": "22",
                            "ToPort": "22"
                        }
                    ]
                }
            },
            "SGBaseIngress": {
                "Type": "AWS::EC2::SecurityGroupIngress",
                "Properties": {
                    "GroupName": { "Ref": "SGBase" },
                    "IpProtocol": "tcp",
                    "FromPort": "80",
                    "ToPort": "80",
                    "SourceSecurityGroupName": { "Ref": "SGBase" }
                }
            }
        }
    }
    ```

* Please suggest agenda topics you'd like to see us cover! Fork this repo, add your items to this list, then submit a Pull Request! If we merge your PR, we'll cover the topic in this session!

## Feature Highlight: AWS::CloudFormation::Authentication

## Focus on the Forums

## Q&A

## Get in Touch
You can find CloudFormation on [Twitter](http://twitter.com/awscloudformer). Evan is on [GitHub](http://github.com/evandbrown), [Twitter](http://twitter.com/evandbrown) or at evbrown (at) amazon.com.

Check out the Application Management Blog at http://blogs.aws.amazon.com/application-management for weekly technical posts about CloudFormation, Elastic Beanstalk, and OpsWorks.

