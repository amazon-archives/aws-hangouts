AWS CloudFormation Office Hours: January 30, 2014
========================================================
Thanks for joining AWS Developer Community Manager Evan Brown for CloudFormation Office Hours. The Hangout starts at 9:00 AM PST on Thursday, January 30, and is scheduled for 30 minutes.

This week we're joined by [Adam Thomas](http://www.linkedin.com/pub/adam-thomas/12/215/621/), a Software Deverlopment Engineer at AWS. You'll learn from Adam how to securely download content from S3 onto your EC2 Instances when using `cfn-init`, and he'll hang around to help answer questions.

[Check out the index](../README.md) for a list of our previous Hangouts, including detailed agenda and recordings.

## Community Agenda Suggestions
* Non-disruptive application upgrade: how to go from v1 to v2 of your app without downtime? Is it possible to deploy v2 of your app on new instances and flip the DNS all using CloudFormation?
* How would I make a scalable way of passing Subnet information from one template to another for use with ELBs? ELB Subnets require "Type: A list of strings" however Template Paremeters can be String, Number, or CSV. Some of my regions have 3 AZs, some have 4. Passing subnets with a CSV such as: "ELBSubnets" : { "Fn::Join" : [",", [{ "Ref" : "PublicSubnet0" }, { "Ref" : "PublicSubnet1" }, { "Ref" : "PublicSubnet2" }]]} does not work. For now I need 1 template for 3 subnet ELBs and 1 template for 4 subnet ELBs.
* Scalable Subnet Patterns & Best Practices for Multiple Regions & Environments (Production/Staging)
* Security groups that reference themselves. When you have a cluster using the same security group and each node in the cluster needs to communicate with other nodes in the cluster there's a need to create a Security Group rule with ports where the source is the same security group ID. How do you do this with CloudFormation?
* Please suggest agenda topics you'd like to see us cover! Fork this repo, add your items to this list, then submit a Pull Request! If we merge your PR, we'll cover the topic in this session!

## Agenda Overview
* New features since the last Hangout
* Feature Highlight: Adam Thomas covers using AWS::CloudFormation::Authentication for secure file and sources downloda with `cfn-init`
* Focus on the Forums: Top posts and answers of the week
* Your Q&A

## About the Q&A
Q&A is enabled for this Hangout. To ask your question, click the Ask a new question button in the bottom-right corner of your screen, like so:

![](img/hangout-qa.png)

You can enter your questions at any point during the hangout. Keep in mind that it takes about 50 seconds before the audio and video to make it through all the tubes to your computer, so by the time you've typed your question we may be on another topic. But don't worry! We've got the final half of the Hangout reserved just for Q&A.

## New Features

## Feature Highlight: AWS::CloudFormation::Authentication

## Focus on the Forums

## Q&A

## Get in Touch
You can find CloudFormation on [Twitter](http://twitter.com/awscloudformer). Evan is on [GitHub](http://github.com/evandbrown), [Twitter](http://twitter.com/evandbrown) or at evbrown (at) amazon.com.

Check out the Application Management Blog at http://blogs.aws.amazon.com/application-management for weekly technical posts about CloudFormation, Elastic Beanstalk, and OpsWorks.

