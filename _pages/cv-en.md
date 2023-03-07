---
title: ""
layout: cv
permalink: /cv/en/
author_profile: false
cv_summary: true

author:
  name: Chai Stofkoper
  avatar : "/assets/images/bio-photo.jpg"

personal_details:
  title: Personal Details
  home: Rotterdam
  birth_date: 14-11-1978

education:
  title: Education
  entries:
    - institute: Conservatory
      year: 2005
    - institute: Gymnasium
      year: 1997

certificates:
  title: Certificates
  entries:
    - Java OCA
    - Terraform Associate
    - Certified DevOps Essentials
    - Splunk Power User
    - Professional Scrum Master
    - Certified Secure (1-4)
    - ISQB foundation
    - ISTQB Agile Extension

skills:
  title: Skills
  entries:
    - Collaboration
    - Abstract Thinking
    - Clear Communication
    - Autonomous
    - Curious and Determined
    - Technical Insight

highlights:
  title: Highlights
  entries:
    - period: 2022 - 2023
      link: shipbuilder
      role: Devops - Development (Fullstack)
      client: Shipbuilder
      summary: Building the frontend (and extending some backend functionality) for a highly configurable project data management application. Technologies used include Typescript, React, AG Grid, Ant Design, NestJs, Docker, github actions.
    - client: Adabtive
      link: adabtive
      period: December 2022 - Present
      role: Co-Founder and Co-Director
      summary: Since 2021 we have started making plans resulting in the official start of Adabtive in December 2022. It is the first steward owned software company in the Netherlands.
    - period: 2020 - 2022
      link: mosar
      role: Devops - Development (Fullstack)
      client: InQuisitive (Internally)
      summary: Setting up and maintaining the infrastructure as code with Terraform in AWS, for the app as well as Jenkins. Building and maintaining build and deploy pipelines in with Jenkins (JcasC, JobDSL). Writing the Angular frontend.
    - period: 2019 - 2022
      link: foreign-affairs
      role: Test - Test Automation
      client: Ministry of Foreign Affairs
      summary: Chain testing and improving and extending the automated test suites for UI and Apis. Bits and pieces of frontend work, containerization and pipelines.

work_experience:
  title: Work Experience
  entries:
    - client: Shipbuilder
      link: shipbuilder
      period: June 2022 - March 2023
      role: Devops - Development (Fullstack)
      knowledge: Typescript, React, Redux, React hooks, NestJs, unit testing, Github actions, Agile, Docker, Docker-compose, Neo4j (Graph database).
      context: Shipbuilder builds an application that is highly configurable where the application can be configured together with clients. This includes data modeling, CRUD options, visualization, menu structure, pages, etc. The code deals with high abstractions and data transformations. The visualization in the frontend is done using Ant D component library and AG Grid.
      tasks:
        - Set up the frontend with React, Redux, Ant D, AG Grid
        - Write the frontend code including custom hooks, persistence in browser and connections to the NestJs backend.
        - Fix bugs and change functionalities in the NestJS backend
        - Set up Docker and Docker compose for running the app in production as well as for development purposes.
        - Set up (basic) pipelines in Github Actions for building and checking the code.
        - Write unit tests and integration tests (Cypress).
        - Partake in all scrum meetings, refinement and application-architecture decision making.
      results: When I started the backend of the application was done for the better part, but the frontend had to be made from scratch. I set this up and wrote the most of the code for it. Together with one more developer we made a first version working. It had some tailor made functionality for a first client running some very large ship building projects.
    - client: Adabtive
      link: adabtive
      period: December 2022 - Present
      role: Co-Founder and Co-Director
      knowledge: Shaping and directing of Adabtive with a technical focus
      context: Since 2021 we have started making plans resulting in the official start of Adabtive in December 2022. It is the first steward owned software company in the Netherlands.
      tasks:
        - Set strategic goals and define plans and timelines
        - HR management and Hiring of new developers
        - Evaluate projects on technical and financial feasibility
      results: Adabtive has started growing. Offering in house realization of software projects, integration and extension of existing software and consultancy services.
    - client: Knab Bank
      link: knab
      period: May 2022 - August 2022
      role: Devops / Test automation
      knowledge: AWS, Terraform, Azure Pipelines, C#, Agile, Angular, Typescript, Cucumber, Selenium
      context: Knab is a bank with a focus on (small) business clients. Their offering is online only so technology is the core of their business. As a daughter company of Aegon, there was a migration ongoing for Aegon investments banking clients to Knab.
      tasks:
       - Instructing / teaching test automation
       - Implementing / extending azure pipelines and Terraform configurations to spin up AWS spot instances and run the automated suites there
       - Write test automation in C#
       - Test features
      results: Worked with different teams on different projects here. One where I was assigned to teach testers on Testautomation in order to raise the general level of testing and testautomation. Then when priorities shifted I was asked to help out in a team where we worked on integrating a number of existing investment clients from another bank, including their portals and accounts. And all the while I worked with Devops to implement some pipelines that ensured test servers be spun up temporarily for use with the automated tests.
    - client: Internally @ InQuisitive
      link: mosar
      period: October 2020 - 2022
      role: DevOps - Development
      knowledge: Typescript, Java, Spring, Angular,Terraform, CloudFormation, Jenkins, Docker, Git, Agile Scrum.
      context: Within InQuisitive we have teamed up in a small group to transition from testers to developers / DevOps Engineers. For this purpose we have been given time and support to do courses and and internal project. We are building a flashcards application named "Mosar". The main goal is to use as many relevant techniques as possible in to gain real world experience and solidify our learnings.
      tasks:
        - Write and maintain all infrastructure as code
        - Set up environments, roles and resources in AWS
        - Setup and maintain build and release pipelines
        - Write the frontend code and frontend unit tests
      results: I have built and rebuilt the infrastructure as code for our project. First using AWS CloudFormation, and later migrating it to Terraform. This entails both the modules and the projects / workspaces (they map to workspaces in Terraform Cloud) that use these modules. All resources such as VPCs, ECS Clusters, EC2 servers, secrets, ECR repositories, roles and policies for both Jenkins and Mosar are maintained here.<BR>Another thing I have built is all the pipelines in Jenkins. Using JCasc and JobDSL with the purpose of haveing everything as-code, I set up build pipelines that get triggered on opening PRs which build the artifacts, run tests and publish images made with Kaniko to AWS ECR. The deploy pipeline, triggered on merging a PR then retrieves this image, and runs Terraform code to run a task withing the existing  ECS cluster.<br>Besides this work I also wrote the frontend code in Typescript using the Angular framework. This includes all html, scss, animations and tests.

    - client: Ministry of Foreign Affairs
      link: foreign-affairs
      period: March 2019 - April 2022
      role: Test - Test Automation - DevOps - Chain Test
      knowledge: Agile, Scrum, DevOps, Test Automation, Java, Javascript, Typescript, Property Based Testing, Backend Testing, Frontend / Angular, Azure, Complex Chain, Codecept, Cypress
      context: The project was to replace existing systems for the processing of visa applications. This encompasses the whole flow from a user filling in the initial forms, the payment and upload portals setup throughout the world, to the processing in The Hague by it's different officers. Also noteworthy are the many (automated) integrations with external parties among which the police, the european visa system (EUVIS) and the immigration service (IND). An approved application would result in a sticker printed on a value document, on the locations at the Ministry's posts, and all registration of those documents.
      tasks:
        - Testing
        - Test Automation (BDD, Java, Javascript, Typescript, Codecept, Cucumber, Cypress)
        - Chain Testing
        - Frontend coding (Bug fixing, minor research tasks)
        - Containerization (setting up local environment)
        - Pipelines (minor maintenance)
      results: In this project I worked mostly on giving the test automation a new impulse. I did this by proposing and executing improvements in the frontend end-to-end tests (using Codecept, and later Cypress), as well as setting up initial test strategy for api tests in Java for the backend. The latter was consequently adopted by the backend developers who wrote the most test for it after that. Together with my colleagues (testers and frontend Engineers) we collaborated on maintaining and extending the end-to-end suite. <br>Another task, at the beginning was to coordinate efforts for the chain testing together with external parties such as the Police and the Ministry of Justice. This was later continued by another colleague. After gaining knowledge of the system and it's complexities I also actively participated in sessions for business analyses and supporting the Product Owners. And where I could I would help out doing some DevOps tasks such as setting up the Docker Compose for local development, or implementing ways to interact with Azure to remove hardcoded test credentials etc.

    - client: Rabobank
      link: rabobank
      period: April 2017 - December 2019
      role: Test - Test Automation - DevOps - Scrum Master
      knowledge: Agile, Scrum, Devops, Test Automation, Browser Testing, Splunk, Java, Javascript, Backend Testing
      context: Our team was responsable for creating and maintaining applications that serve the marketing teams by enabling them to fully personalize the messages to Rabobanks customers.
      tasks: Test - Test Automation - DevOps - Scrum Master
      results: The Rabobank is an environment in which changes are made rapidly, both in the way of working and in the complex technical landscape. Our team had the responsibility for maintaining a few legacy systems for which I wrote automated regression suite. The framework I wrote for that was then also adopted by other colleagues in our team and in outside teams. Besides this we worked on new software that was deployed to PCF on Azure as per the new architecture standards. It was my task in the team to setup all the dashboards and alerting for our services using Splunk. Critical thinking and assertive communication was important to prevent errors from happening before even starting the build. And for about one year I also had the role of Scrum Master in the team.

    - client: Province of Gelderland
      link: gelderland
      period: April 2017 - April 2019
      role: Test - Test Automation
      knowledge: Agile, Scrum, Test Automation, Chain Testing, Acceptance Testing, Migrations (Open Text and Sharepoint), Java, Selenium, Python
      context: As a tester for the Province Gelderland I have been part of many different projects; Migrating Open Text (Enterprise information management) and Sharepoint(2010 to 2013), as well as development of a new application for the subsidy applications.
      tasks:
        - Test
        - Agile Team Member
        - Oversee and help out with Acceptance Tests
      results: Within the province many different processes happen simultaneously. Professionalizing the testing in itself, maintaining legacy systems, development of new systems and transitioning into a directive organisation where all IT is outsourced. This calls for strict quality control. The challenge was to be part of many different projects, testing different systems and at the same time gain in depth knowledge of these systems, especially the legacy systems where information and documentation was sparse. I was part of both the testing efforts and of the general effort to improve the quality of the test process where we looked at roles and responsibilities, management of environments, planning, documentation and opportunities for test automation. Another important part of my work was to get the officers of the province together with the build teams and work towards a shared understanding.

    - client: Homefashion Group
      link: homefashion-group
      period: September 2016 - February 2017
      role: Test
      knowledge: Jira, Trac, Youtrack, XML, Java, Selenium, Python, Exploratory Testing
      context: In the hectic environment of a retailer that wants and must modernize it's systems we maintained legacy systems and build new systems (web shop)
      tasks:
        - Test
        - Test Automation
        - Chain Testing
        - SOAP service Testing
      results: In the Homefashion Group I was part of a team of three testers. Together we were responsible for testing the web shop that was being rebuild, as well as new web shops that were being added. Apart from this it was my personal responsibility to test the legacy ERP systems (Progress). This was especially challenging because the system was constantly being worked on to support ever changing product lines, delivery channels and transport ways. I twas not easy to come to understand the system since it was complex, there was no documentation and full of temporary fixes and technical debt. For the web shops I built a small test framework in Java and Selenium which we used to write our tests together with one of my colleagues.

    - client: Exact
      link: exact
      period: July 2016 - August 2016
      role: Test
      knowledge: Testing, Test Automation, Team Foundation Server, C#, Selenium
      context: I worked as Scrum Team member in the Accounting Core team of Exact Online
      tasks:
        - Test
        - Test Automation
        - Regression Testing
      results: Exact Online provides customers with software for there accounting. Withing this project I was part of the Accounting Core team which was responsible for some of the core functionalities. It requires a detailed scrutiny and critical insights to deliver the required quality up to standards. I contributed in the form of Exploratory Testing as well as writing automated regression tests within the custom framework, as well as in C# with selenium. Exact Online was at that moment moving towards using the latter for all the tests. Apart from this I was an active part in improving the Scrum process for instance by making User stories and Acceptance criteria more explicit.

---

# Chai Stofkoper - DevOps - Development

## Profile

'Sharp, discerning, ambitious, collaborative'. Those are words that resonate well with me. I ask questions and dig deep in order to find possibilities for solutions. I regard challenges mainly as starting points to learn something new, and to continue growing in my work and as a person. I am always open to suggestions, I appreciate direct and clear communication and  an informal atmosphere. From my work as a tester and test automation engineer I gained a sharp eye for detail, and acute awareness of both risk and quality. The last few years I have extended my knowledge and working experience in topics and techniques such as Java, Javascript, Typescript, Python, Haskell, AWS, Pipelines (Jenkins), containerization (Docker and Compose), DevOps, Agile and more. I am passionate about Linux, Vim, containers, exotic music and mathematics!

## Ambitions

After a period of transition I have now fully plunged into a career in development and DevOps. In December 2022 I co-founded Adabtive. My main focus has always remained the same: learn as much as I can. I want to grow further both as an engineer as well as co-director at Adabtive.

Topics that interest me a lot at the moment are Kubernetes, Pipelines and AWS. And aside from that of course just being a better developer everyday. Deliver features, collaborate with colleagues trying to get the best results from the start. Start with good thinking, and clear communication so we can build the software to support the exact business goals they require.

For a next assignment I hope to dive into new problems, get to know interesting people and keep on learning!

## {{ page.highlights.title }}
{% for highlight in page.highlights.entries %}
### [{{ highlight.period }}: {{ highlight.role }} @ {{ highlight.client }}](#{{ highlight.link }})
{{ highlight.summary }}
{% endfor %}
## {{ page.work_experience.title }}
{% for work_experience in page.work_experience.entries %}
### Client: {{ work_experience.client }}
{: #{{work_experience.link}} }

**Period:** {{ work_experience.period }} <br>
**Role(s):** {{ work_experience.role }} <br>
**Knowledge:** {{ work_experience.knowledge }} <br>
**Context:** {{ work_experience.context }} <br>
**Tasks:** {% for task in work_experience.tasks %}
 - {{task}}
     {% endfor %}
**Results:** {{ work_experience.results }} <br>
{% endfor %}
