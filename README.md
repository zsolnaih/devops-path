# devops-path
# DevOps Path 🚀

Welcome to my **DevOps learning journey**!

I'm currently working on building solid DevOps engineering skills with the goal of transitioning into a DevOps-focused role within the next 6–12 months. This repository documents my learning path, progress, notes, and hands-on experiments along the way.

## 🎯 Goals

- Gain practical knowledge in DevOps tools, cloud infrastructure, and automation practices
- Build a strong personal DevOps portfolio through real-world projects and documentation
- Prepare for and achieve the following certifications:
  - [ ] **AWS Certified Solutions Architect – Associate (SAA-C03)**
  - [ ] **HashiCorp Certified: Terraform Associate**
  - [ ] **Certified Kubernetes Administrator (CKA)**

## 📚 What's Included

This README will serve as a living journal of my DevOps journey. It will contain:

- 🧠 Concepts I've learned
- 🔧 Tools and techniques I've explored
- ✍️ Reflections and progress updates
- ✅ Milestones and achievements

---

## 🗓️ Weekly Progress Log

_This section will be continuously updated as I move forward._

### Week 0 (2025-08-03)
- ✅ Created this repository and defined my DevOps roadmap
- 📝 Outlined certification goals: AWS SAA, Terraform Associate, CKA
- 🛠️ Set up learning environment using a local K3s cluster on Raspberry Pi 5 and a Kubernetes cluster via Docker Desktop on Windows

**Notes & Challenges:**
- Faced an issue where the Docker Desktop Kubernetes cluster wouldn't start due to insufficient memory allocation in WSL2.
- Discovered that memory settings are no longer adjustable via the Docker Desktop GUI.
- Resolved the problem by creating and configuring the `.wslconfig` file at the Windows system level to increase available memory, followed by a WSL restart. The cluster then started correctly.
- Installed and configured [`kubectx`] inside WSL to simplify context switching between my two test Kubernetes clusters (Raspberry Pi K3s and Docker Desktop).
- Verified that `kubectx` properly lists both contexts and allows seamless switching using `kubectx <context-name>`, improving my daily workflow.


### Week 1 (2025-08-10)
- 📚 Started preparing for the **AWS Certified Solutions Architect – Associate (SAA-C03)** exam.
- 🎯 Based on personal and online recommendations, began **Stephane Maarek's** Udemy course.
- ⏳ Progress so far: ~35% of the course completed.
- 🧠 Topics covered in depth:
  - **IAM**: Roles, Policies, Groups and Users
  - **EC2**: Instances, cost-saving strategies, Load Balancers, Auto Scaling Groups, storage types, networking and much more
  - **Databases**: RDS, Aurora, and ElastiCache
  - **Route 53**: DNS services and configurations

**Notes & Challenges:**
- Created my own AWS account and followed all hands-on exercises in a real environment.
- Learned that **Security Groups** can be tricky — experimented with rules to understand behavior.
- Needed to revisit the database section multiple times to get a better understanding of **Aurora** and **ElastiCache** concepts.
- Reached the first **Solution Architect use cases** in the training — really enjoyed these, as Stephane provides excellent examples.


### Week 2 (2025-08-19)
- 📚 Continued preparing for the **AWS Certified Solutions Architect – Associate (SAA-C03)** exam.
- 🧠 Topics studied in detail:
  - **Amazon S3**: storage classes, durability, lifecycle policies
  - **CloudFront** and **AWS Global Accelerator**
  - Additional storage services: **Snow Family**, **Amazon FSx**, **Storage Gateway**, **DataSync**
  - Queueing & messaging services: **SQS**, **Kinesis**, **AmazonMQ**, **SNS**

**Notes & Challenges:**
- 🌴 This week included a **family vacation**, so I had less time to study compared to the previous week.  
- 🚀 Looking forward to diving deeper and resuming a more intensive study pace next week. 

---

## 🔗 Connect

If you're on a similar journey or have feedback/suggestions, feel free to reach out or follow along!

Thanks for stopping by! 🙌
