This example deploys a single PostgreSQL RDS within a fresh new VPC.

 * The RDS instance can be accessed over the internet (not just by EC2 instances 
   within the VPC).
   
 * Any EC2 instances deployed to the VPC will automatically get a public IP you 
   can connect to them on (as long as you allow this with the relevant security 
   group firewall rules).

 * Backups of the RDS are automated and a final snapshot is taken upon termination.

 * The instance has deletion protection enabled to prevent accidental loss.

 * The RDS storage is encrypted.

 * The VPC has 3 subnets that span the 3 availability zones, so one could deploy across zones.

 * The RDS makes use of [auto-scaling 
   storage](https://aws.amazon.com/about-aws/whats-new/2019/06/rds-storage-auto-scaling/), 
   so you should hopefully never run out of space (unless you set the max too low).
