# devops-path
# DevOps Path 🚀

Welcome to my **DevOps learning journey**!

I’m passionate about understanding how modern DevOps practices and tools shape reliable, automated infrastructure.
This repository documents my learning journey as I explore and build real, hands-on experience with these technologies.

## 🎯 Goals

- Gain practical knowledge in DevOps tools, cloud infrastructure, and automation practices
- Build a strong personal DevOps portfolio through real-world projects and documentation
- Prepare for and achieve the following certifications:
  - [x] **AWS Certified Solutions Architect – Associate (SAA-C03)**
  - [x] **HashiCorp Certified: Terraform Associate**
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


### Week 3 (2025-08-25)
- 📚 Continued preparing for the **AWS Certified Solutions Architect – Associate (SAA-C03)** exam.
- 🧠 Topics studied in detail:
  - **Containerization**: ECS, EKS, Fargate
  - **Databases**: DynamoDB, DocumentDB, Neptune, Keyspaces, Timestream
  - **Data Analytics**: Athena, Redshift, OpenSearch, QuickSight
  - **Machine Learning Services**: Rekognition, Transcribe, Polly, Translate, Lex, SageMaker, Kendra
  - **Monitoring & Audit**: CloudWatch, CloudTrail, AWS Config

**Notes & Challenges:**
- ✉️ I wanted to experiment with sending an email notification triggered by a **CloudTrail event**.  
- 🔗 Without EventBridge, this was straightforward by connecting CloudTrail directly to an SNS topic.  
- ⚡ With EventBridge in the middle, I had to define custom rules and tweak them several times before it worked.  
- ✅ Eventually, I managed to build a small **test project** where EventBridge captures a CloudTrail event and routes it through SNS to my email — a great hands-on exercise that deepened my understanding of event-driven architectures.  


### Week 4 (2025-09-01)
- 📚 Completed the **AWS SAA Udemy training by Stephane Maarek** 🎉
- 🧠 Topics covered this week:
  - **Identity & Access Management**: deeper dive into AWS IAM
  - **Security & Encryption**: KMS, SSM Parameter Store, Shield, WAF
  - **Networking**: VPC in more detail
  - **Disaster Recovery & Migration**: DMS, AWS Backup
  - **Other useful services**: CloudFormation, SES, PinPoint, SSM, Cost Center, Outposts, AWS Batch, AppFlow, Amplify

**Notes & Challenges:**
- 📖 Explored the **AWS Well-Architected Framework**, which gave me a structured way of thinking about best practices.  
- 🔄 Next week marks the beginning of the **exam preparation phase** — I plan to rewatch some parts of the training that didn’t fully stick, and start practicing with **test exams** to assess my readiness.  


### Week 5 (2025-09-07)
- 📝 Focused entirely on **practice exams** this week.
- 📊 My first attempt scored **60%**, which I was fairly satisfied with as a starting point.
- ✅ Completed a total of **3 practice exams** so far — the latest one was already a **passing score on the first try**, showing clear progress.
- 🔄 I will continue practicing with more test exams over the next couple of weeks to strengthen weaker areas.
- 🎯 If the trend continues, I feel confident that I’ll be ready to book the **real certification exam** soon.


### Week 6 (2025-09-17)
- 📝 Took **two new practice exams** this week — both were **passed on the first attempt** 🎉
- 🔁 Revisited some of the earlier practice exams as well, consistently scoring **above 90%**
- 📊 These results give me strong confidence in my preparation
- 🎯 I believe that within the next **1–2 weeks** I’ll be ready to attempt the **real certification exam**


### Week 7 (2025-09-25)
- 📚 This week was intense — so intense that I’m a bit late with this update!
- 📝 Spent the beginning of the week actively preparing for the **AWS SAA exam**.
- 🖥️ On Sunday evening, I scheduled the exam, and the following two days were dedicated fully to revision.
- 🎉 Yesterday I took the exam and I’m very happy to announce that I **passed the AWS Certified Solutions Architect – Associate (SAA-C03)**! 🚀
- 🎯 Next target: **HashiCorp Terraform Associate certification**.

**Notes & Challenges:**
- ❓ Going into the exam, I wasn’t sure exactly what to expect.  
- 🔄 Completed all of **Stephane Maarek’s practice exams** multiple times, which proved to be very useful.  
- 💡 For additional practice, I purchased a **SkillCertPro AWS SAA bundle** (~1200 questions). I tried 1–2 exams, but found the question quality poor and often unclear, so I decided not to continue with them.  
- ✅ The real exam questions were very similar in style and clarity to **Stephane’s practice questions**, confirming their value. I can confidently recommend his course to anyone preparing for the SAA exam.


### Week 8-9 (2025-10-04)
- ⏸️ Took a short rest day after passing the AWS SAA exam, then continued on my planned path.  
- 📚 Started and completed a **Terraform Associate Udemy training** this week.  
- 💡 The course was very useful — I feel I now understand Terraform concepts and workflows much more clearly.  
- 🛠️ Next steps: begin solving **practice exams** and actively prepare for the certification.  
- 📂 I also want to start writing **Terraform practice code** and share it here in this repository -> [Basic Nginx](https://github.com/zsolnaih/devops-path/blob/main/Terraform/Nginx/README.md).  
- 📄 The code I wrote during the training is also included in this repo, but those were mainly small, isolated examples focused on testing individual Terraform features.  

**Notes & Challenges:**
- 🤔 I initially started with the **Bryan Krausen & Gabe Maentz** Udemy course, but since it’s a bit outdated, many of the labs didn’t work with newer Terraform or provider versions, requiring troubleshooting.  
- 🔄 I switched to **Zeal Vora’s training**, whose labs were up-to-date and worked smoothly without issues.  
- 🎧 It took a short time to get used to his Indian accent, but it wasn’t a problem overall.  
- ⏩ Since he explained even the very basics in great detail, I watched most of the videos at **1.25x speed**, skipping some chapters I already knew.  
- 💡 What I especially appreciated: he frequently shared **real-world industry examples and best practices**, which added significant value.  


### Week 9 (2025-10-13)
- 🧠 Continued active preparation for the **HashiCorp Certified: Terraform Associate** exam through practice tests and hands-on exercises.  
- 🧾 Registered for the online exam, which I took yesterday — and I’m happy to share that I **successfully passed** and earned my **Terraform Associate certification**! 🎉  
- 🏗️ Applied my Terraform knowledge in a **real-world project** this week:  
  - We operate a **SonarQube** application on AWS using a basic EC2 + RDS setup that was previously managed manually.  
  - This week, I imported both the **test** and **production** environments into Terraform, so from now on, they will be fully managed as **Infrastructure as Code (IaC)**.  
- ⚙️ Additionally, we have another AWS-hosted **GitLab** deployment (EKS + RDS + EC2 runners + EC2 Gitaly) that’s already managed by Terraform — except for the **CloudWatch alarms**.  
  - My next goal is to bring those alarm configurations under Terraform management as well.  
- 🎯 With Terraform completed, I’m now moving on to the **Certified Kubernetes Administrator (CKA)** exam preparation. I’ve already enrolled in a **Udemy course** to get started.

**Notes & Challenges:**
- 🔍 Compared to AWS and Terraform, I found **fewer structured courses and practice exams** available for the CKA exam.  
- 💪 I expect this to be the **most challenging certification** in my current journey, but I’m confident I can prepare effectively and try my best.  


### Week 10–11 (2025-10-27)
- 🎓 Began the **Certified Kubernetes Administrator (CKA)** Udemy training and have already completed roughly **50%** of the course.  
- 🔍 Found only **a few CKA preparation trainings** on Udemy — significantly fewer than for AWS or Terraform.  
- 🧠 The current course does a great job explaining **Kubernetes fundamentals**, and the **KodeKloud sandbox environment** provides an excellent environment to practice the basics hands-on.  
- ⚙️ However, for more complex Kubernetes topics — such as **TLS certificate management** or **cluster upgrades** — the explanations were not entirely clear, and I had to research these areas using additional sources.  
- 🤔 I’m a bit concerned about the **CKA exam**, as it’s **highly practical**, and while the course gives good exposure to core concepts, it doesn’t fully cover the real-world complexity of certain topics.  
- 📘 Nevertheless, I plan to complete the entire course since it provides a solid overall understanding of how Kubernetes works. I’ll likely supplement it with more advanced labs and documentation before attempting the certification.  

**Notes & Challenges:**
- 🧩 The main challenge remains balancing **theory and hands-on practice** — especially for the more intricate parts of Kubernetes.  
- 💡 Despite these challenges, I feel I’m gaining a much clearer mental model of Kubernetes internals and cluster operations, which will help later in both the exam and real-world use cases.  


### Week 12–13 (2025-11-09)
- 🕒 The last two weeks have been quite busy, so I had limited time to continue my learning path.  
- 🔄 Fortunately, things should return to normal starting tomorrow, and I’m planning to get back to active study again.  
- 📚 Despite the limited time, I still made some gradual progress and continued exploring **Kubernetes concepts**.  
- 🔐 Learned about **Kubernetes Security**, including:
  - Authentication and Authorization within the cluster  
  - **RBAC** (Role-Based Access Control)  
  - **TLS certificates** and their management  
  - **User and Service Account** management  
- 💾 Also studied **Kubernetes Storage Management** — understanding how persistent volumes, storage classes, and dynamic provisioning work.  
- 🌐 Currently learning about **Kubernetes Networking**, which will be my main focus over the next few days.  

**Notes & Challenges:**
- 🧩 Balancing time for study has been the biggest challenge recently, but even small progress keeps the momentum going.  
- 💪 Feeling motivated to return to a more consistent rhythm starting next week and continue working toward the **CKA certification**.  


---

## 🔗 Connect

If you're on a similar journey or have feedback/suggestions, feel free to reach out or follow along!

Thanks for stopping by! 🙌
