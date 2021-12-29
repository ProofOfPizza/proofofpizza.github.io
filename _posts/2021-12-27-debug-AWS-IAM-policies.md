---
title: "An easy approach to debugging IAM policies on AWS"
categories:
  - tech
tags:
  - IAM
  - AWS
  - infrastructure
  - infrastructure-as-code
  - terraform
---

There are tons of tutorials with screenshots all over the place explaning the various setups to get started with AWS. How do you set up an EC2 instance, or how to setup an ELB etc etc.
However, chances are, you like to define your infra as code. As do I. AWS has it's cloud formation templates to do this, or you can write code that uses the AWS-sdk. I myself like terraform for this,
but however you do it: your infra gets coded and put into git for version control. From there you maintain it, and apply it to create your actual infrastructure.

In AWS there is almost nothing you can do without IAM roles and policies, and where you CAN do things with usernames and passwords it is definitely NOT recommended. You will have to think about these, manage them, store them securely and find a way to access them, while AWS as do all the cloud providers, have IAM (Identity access management) for this specific purpose. It is a system that allows for very granular control of access and authorizations.

So you follow some suggestions from [StackOverflow][so], combine the wisdom with some blog posts and tinker with it for your own specific needs. After all isn't that what ~~life~~ ~~coding~~ ~~frustration~~ life is all about ?

Now obviously something does't work. You get an error, or you can not even find the error, but something is wrong. You suspect the IAM role, because that is often where it's at right ?
Okay, I agree and here are some simple steps to help you figure stuff out.

1. Give whatever role you suspect is the culprit (semi)admin rights. If this does not solve your problem: IAM is not your problem and you should look elsewhere. ([security groups][sg] I am looking at you!)
AWS works in a way that you have to create roles, policies and then policy attachments to ensure the most granular control over things. The one you want to edit is the policy.
For instance if you want to create admin like role for a specific region (let's try to at least not dish out root-like access everywhere, right!?) you can define a policy like:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": [
                        "eu-central-1"
                    ]
                }
            }
        }
    ]
}
```
\
Note that some global actions such as IAM (listing users for example) are not located in `eu-central-1` but only in `us-east-1`. So in some specific cases you might need to tweak this. See the [aws-docs][docs] for further reading. But generally for all things that live inside VPC's and thus inside regions this is (more than!) enough. Retry and see: if your setup now works then you know the problem was with IAM and you can now further drill down on the specific problem, or the exact policy needed. Whatever you do: Please do not be content and leave it at this. Throwing around admin roles is a bad habit, and a dangerous one. And while trying to debug one role at a time is difficult, trying to fix this for a dozen or so roles is a task you do not wish on anyone.

2. Drill down in steps. For instance: if your app is doing something with an EC2 instance and s3 buckets you can start off by eliminating everything else:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": ["ec2:*", "s3:*"],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "aws:RequestedRegion": [
                        "eu-central-1"
                    ]
                }
            }
        }
    ]
}
```

3. Rinse and repeat: Eliminate things, by specifying the things you think you need, and thus removing everything else. For instance you want to restrict the resources to just a specific EC2 instance.
But how do we write that specifically? Trial and error has cost me a lot of time, so I do not recommend it. Instead do this: Login to the AWS console with a role that has rights to IAM. (I know I know we all hate the AWS console, and weren't we doing infrastructure-as-CODE ?? Just bear with me girls and guys!) Now search for IAM in the search bar and click on policies and create new policy. Now here there are two important things you can do:
 - Click on JSON, paste or write your JSON definition of a policy, click next next and at the review stage you can see in the console what your exact permissions are. Sometimes your JSON is correct, and also terraform does not complain, AWS loves your definition, but for instance if the instance is not described correctly it just wont work (without error!).
 - Build your definition through the UI, search and click on the right resources and actions, (maybe use another tab to find the instance ID of your ec2 instance), and when it is all done click next next and verify it in the review stage. If you are happy with the way that looks great!
 - Now you can save it and manually in the console attach it to the role you were using and see if it is fixed, or immediately take the last step: go back a few clicks in the console and click on JSON. It will now display the policy generated by AWS in JSON format. You can now use this in yout terraform code or cloud formation template or whatever you use. You might end up with something like
     ```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketPolicyStatus",
                "s3:GetBucketPublicAccessBlock",
                "s3:GetBucketTagging",
                "s3:GetBucketWebsite",
                "s3:GetBucketLogging",
                "s3:GetBucketVersioning",
                "s3:GetBucketAcl",
                "s3:GetBucketNotification",
                "s3:GetBucketPolicy",
                "ec2:GetConsoleOutput",
                "s3:GetBucketObjectLockConfiguration",
                "s3:GetEncryptionConfiguration",
                "ec2:GetPasswordData",
                "ec2:GetLaunchTemplateData",
                "s3:GetBucketRequestPayment",
                "s3:GetBucketCORS",
                "s3:GetBucketOwnershipControls",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::*",
                "arn:aws:ec2:eu-central-1:640753244498:instance/i-0a1d7b89af7d0bc1e"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "ec2:GetDefaultCreditSpecification",
                "ec2:DescribeTags",
                "ec2:GetCoipPoolUsage",
                "ec2:DescribeVpnConnections",
                "ec2:GetEbsEncryptionByDefault",
                "ec2:DescribeVolumesModifications",
                "ec2:GetHostReservationPurchasePreview",
                "ec2:GetNetworkInsightsAccessScopeAnalysisFindings",
                "ec2:DescribeFastSnapshotRestores",
                "ec2:GetNetworkInsightsAccessScopeContent",
                "ec2:GetSubnetCidrReservations",
                "ec2:GetConsoleScreenshot",
                "ec2:GetReservedInstancesExchangeQuote",
                "ec2:GetInstanceTypesFromInstanceRequirements",
                "ec2:DescribeScheduledInstances",
                "ec2:GetSerialConsoleAccessStatus",
                "ec2:GetAssociatedIpv6PoolCidrs",
                "ec2:DescribeScheduledInstanceAvailability",
                "ec2:GetSpotPlacementScores",
                "ec2:GetEbsDefaultKmsKeyId",
                "ec2:DescribeElasticGpus"
            ],
            "Resource": "*"
        }
    ]
}
```

You can edit some things here like the optional Sid and try again. Rinse and repeat people, rinse and repeat until you are sure that:
1. It works
2. You have restricted access to sensible levels. Either your own best thinking plus some extra for decent paranoia or maybe to comply with your companies rules and regulations.

Be sure to delete any things you might've (accidentally?) saved in the process because no one wants unused resources laying around in AWS!
Also please note: do not copy and paste these policies as they are, they will not fit your purpose. Instead follow the simple plan laid out here, it will give you a more robust way of working and save you time. Now, and later on because rest assured: You will mess with IAM again, always.

[so]: https://stackoverflow.com/
[sg]: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-security-groups.html
